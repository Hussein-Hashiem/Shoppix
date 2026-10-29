import { computed, inject, Service, signal } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { finalize, Observable, shareReplay, tap } from 'rxjs';
import { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse } from '../models/auth.model';
import { refreshTokenCredentials } from '../models/refreshToken.model';

@Service()
export class AuthService {
  baseUrl = environment.apiUrl + '/auth';
  http = inject(HttpClient);
  private refreshToken = signal<string | null>(localStorage.getItem('refreshToken'));
  private refreshTokenExpiration = signal<string | null>(localStorage.getItem('refreshTokenExpiration'));
  private refreshInProgress$: Observable<LoginResponse> | null = null;

  readonly isLoggedIn = computed(() => {
    const token = this.refreshToken();
    const expiration = this.refreshTokenExpiration();

    if (!token || !expiration) return false;

    return new Date(expiration) > new Date();
  });

  handleLoginSuccess(access: string, refreshToken: string, refreshTokenExpiration: string) {
    localStorage.setItem('accessToken', access);
    localStorage.setItem('refreshToken', refreshToken);
    localStorage.setItem('refreshTokenExpiration', refreshTokenExpiration);
    this.refreshToken.set(refreshToken);
    this.refreshTokenExpiration.set(refreshTokenExpiration);
  }
  register(data: RegisterRequest): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(`${this.baseUrl}/register`, data);
  }

  login(credentials: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.baseUrl}/login`, credentials);
  }

  logout() {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('refreshTokenExpiration');
    this.refreshToken.set(null);
    this.refreshTokenExpiration.set(null);
  }

  refreshTokens(credentials :refreshTokenCredentials): Observable<LoginResponse> {
    if(this.refreshInProgress$) return this.refreshInProgress$;
    this.refreshInProgress$ = this.http.post<LoginResponse>(`${this.baseUrl}/refresh`, credentials).pipe(
      tap((response) => {
        this.handleLoginSuccess(response.token, response.refreshToken, response.refreshTokenExpiration);
      }), 
      finalize(()=> this.refreshInProgress$ = null),
      shareReplay(1)
    );
      return this.refreshInProgress$;
  }
  
  getTokens(): { token: string, refreshToken: string, refreshTokenExpiration: string } {
    return {
      token: localStorage.getItem('accessToken') ?? '',
      refreshToken: localStorage.getItem('refreshToken') ?? '',
      refreshTokenExpiration: localStorage.getItem('refreshTokenExpiration') ?? ''
    }
  }
}