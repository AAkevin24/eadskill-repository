package main

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"os"
	"os/exec"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

const (
	DBHost   = "meu-banco.xxx.us-east-1.rds.amazonaws.com"
	DBUser   = "eadskill"
	DBName   = "ead-postgres-db"
	S3Bucket = "eadskill-db-backup-kevin24"
	Region   = "us-east-1"
)

func main() {
	timestamp := time.Now().Format("2006-01-02_15-04-05")
	backupFile := fmt.Sprintf("/tmp/%s_backup_%s.sql", DBName, timestamp)

	// Dump no banco
	err := dumpDatabase(DBHost, DBUser, DBName, backupFile)
	if err != nil {
		log.Fatalf("Erro ao criar dump do banco: %v", err)
	}

	// Envio para o S3
	err = uploadToS3(backupFile, S3Bucket)
	if err != nil {
		log.Fatalf("Erro ao enviar backup para o S3: %v", err)
	}

	// Remove o backup local
	err = os.Remove(backupFile)
	if err != nil {
		log.Printf("Aviso: Não foi possível remover o arquivo local: %v", err)
	} else {
		log.Println("Arquivo de backup removido com sucesso.")
	}
}

// Executar o dump do PostgreSQL
func dumpDatabase(host, user, dbName, outputFile string) error {
	cmd := exec.Command("pg_dump", "-h", host, "-U", user, "-d", dbName, "-F", "c", "-f", outputFile)
	cmd.Env = append(os.Environ(), "PGPASSWORD="+os.Getenv("DB_PASSWORD"))

	var stderr bytes.Buffer
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("erro ao executar pg_dump: %v (%s)", err, stderr.String())
	}

	log.Println("Backup do banco de dados criado com sucesso:", outputFile)
	return nil
}

// Enviar o arquivo para o S3
func uploadToS3(filename, bucket string) error {
	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(Region))
	if err != nil {
		return fmt.Errorf("erro ao carregar configuração AWS: %v", err)
	}

	client := s3.NewFromConfig(cfg)

	file, err := os.Open(filename)
	if err != nil {
		return fmt.Errorf("erro ao abrir arquivo para upload: %v", err)
	}
	defer file.Close()

	_, err = client.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket: &bucket,
		Key:    &filename,
		Body:   file,
	})
	if err != nil {
		return fmt.Errorf("erro ao fazer upload para o S3: %v", err)
	}

	log.Println("Backup enviado para S3 com sucesso:", filename)
	return nil
}
