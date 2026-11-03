import { Component, effect, inject, OnInit, signal } from '@angular/core';
import { Navbar } from './shared/components/navbar/navbar';
import { Footer } from './shared/components/footer/footer';
import { NavigationCancel, NavigationEnd, NavigationError, NavigationStart, Router, RouterOutlet } from '@angular/router';
import { initFlowbite } from 'flowbite';
import { AuthService } from './core/services/auth.service';
import { toSignal } from '@angular/core/rxjs-interop';
import { filter, map } from 'rxjs';

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

  isLoading = toSignal(
    this.router.events.pipe(
      filter(event =>
        event instanceof NavigationStart ||
        event instanceof NavigationEnd ||
        event instanceof NavigationError ||
        event instanceof NavigationCancel
      ),
      map(event => {
        console.log(event instanceof NavigationStart)
        return event instanceof NavigationStart;
      })
    ),
    { initialValue: true }
  );
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
