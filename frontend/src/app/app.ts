import { Component, effect, inject, OnInit, signal } from '@angular/core';
import { Navbar } from './shared/components/navbar/navbar';
import { Footer } from './shared/components/footer/footer';
import { Router, RouterOutlet } from '@angular/router';
import { initFlowbite } from 'flowbite';
import { AuthService } from './core/services/auth.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Footer, Navbar],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  protected readonly title = signal('Shoppix');
  private router = inject(Router);
  private auth = inject(AuthService);

  constructor(){
    effect(()=>{
        if (!this.auth.isLoggedIn() && this.isOnProtectedPage()) {
        this.router.navigate(['/home'], {
          queryParams: { returnUrl: this.router.url },
          replaceUrl: true,
        });
      }
    })
  }
  isOnProtectedPage(): boolean {
    const protectedRoutes = ["/order-history"];
    return protectedRoutes.includes(this.router.url);
  }
  ngOnInit(): void {
    initFlowbite();
  }
}
