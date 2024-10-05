import { Controller, Get, Post, Delete, UseInterceptors, UploadedFile, Res, Param } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { join } from 'path';
import { Response } from 'express';
import * as fs from 'fs';
import { ipAddress, port } from './main'; // Import the variables


interface FileMetadata {
  filename: string;
  uploadTime: string;
}
// // Add the IP address and port dynamically
// const ipAddress = '0.0.0.0';  // Adjust this to be dynamic in your main.ts
// const port = 3000;

@Controller('files')
export class AppController {
  private readonly metadataFile = './uploads/file-metadata.json';

  constructor() {
    if (!fs.existsSync('./uploads')) {
      fs.mkdirSync('./uploads');
    }
    if (!fs.existsSync(this.metadataFile)) {
      fs.writeFileSync(this.metadataFile, JSON.stringify([]));
    }
  }

  @Get('server-info') // API route to expose IP address and port
  getServerInfo() {
    return { ipAddress, port };
  }

  @Post('upload')
  @UseInterceptors(FileInterceptor('file', {
    storage: diskStorage({
      destination: './uploads',
      filename: (req, file, callback) => {
        // Store the file with its original name
        callback(null, file.originalname);
      },
    }),
  }))
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    const metadata: FileMetadata = {
      filename: file.originalname,
      uploadTime: new Date().toISOString(),
    };

    let existingMetadata = JSON.parse(fs.readFileSync(this.metadataFile, 'utf8'));

    existingMetadata = existingMetadata.filter((meta: FileMetadata) => meta.filename !== file.originalname);
    existingMetadata.push(metadata);

    fs.writeFileSync(this.metadataFile, JSON.stringify(existingMetadata, null, 2));

    return { message: 'File uploaded successfully', fileName: file.originalname };
  }

  @Get('list')
  listFiles() {
    const metadata = JSON.parse(fs.readFileSync(this.metadataFile, 'utf8'));
    return metadata;
  }

  @Get('download/:filename')
  downloadFile(@Param('filename') filename: string, @Res() res: Response) {
    const file = join(__dirname, '..', 'uploads', filename);
    if (fs.existsSync(file)) {
      return res.download(file);
    } else {
      res.status(404).send({ message: 'File not found' });
    }
  }

  @Delete('delete/:filename')
  deleteFile(@Param('filename') filename: string, @Res() res: Response) {
    const filePath = join(__dirname, '..', 'uploads', filename);
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);

      let existingMetadata = JSON.parse(fs.readFileSync(this.metadataFile, 'utf8'));
      existingMetadata = existingMetadata.filter((meta: FileMetadata) => meta.filename !== filename);
      fs.writeFileSync(this.metadataFile, JSON.stringify(existingMetadata, null, 2));

      return res.send({ message: 'File deleted successfully' });
    } else {
      return res.status(404).send({ message: 'File not found' });
    }
  }
}
