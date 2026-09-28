import { HttpClient } from '@angular/common/http';
import { inject, Service } from '@angular/core';
import { environment } from '../../../environments/environment';

@Service()
export class ApiService {
  http = inject(HttpClient);
  baseUrl = environment.apiUrl;
}
