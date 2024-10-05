import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

// Declare variables to hold the IP address and port
export let ipAddress: string;
export let port: number;

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Capture command-line arguments for IP and port, or use defaults
  const args = process.argv.slice(2);
  ipAddress = args[0] || '0.0.0.0';
  port = parseInt(args[1], 10) || 3000;

  await app.listen(port, ipAddress);
  console.log(`Application is running on: http://${ipAddress}:${port}`);
}

bootstrap();
