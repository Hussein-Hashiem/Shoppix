import { computed, inject, Service, signal } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse } from '../models/auth.model';

@Service()
export class AuthService {
  baseUrl = environment.apiUrl + '/auth';
  http = inject(HttpClient);
  private accessToken = signal<string | null>(localStorage.getItem('accessToken'));

  readonly isLoggedIn = computed(() => !!this.accessToken());

  handleLoginSuccess(access: string) {
    localStorage.setItem('accessToken', access);
    this.accessToken.set(access);
  }
  register(data: RegisterRequest): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(`${this.baseUrl}/register`, data);
  }

  login(credentials: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.baseUrl}/login`, credentials);
  }

  logout() {
    localStorage.removeItem('accessToken');
    this.accessToken.set(null);
    //  adding refresh token with cookies part
  }
}
