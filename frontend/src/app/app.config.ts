import { ApplicationConfig, provideBrowserGlobalErrorListeners } from '@angular/core';
import { provideRouter, withComponentInputBinding, withInMemoryScrolling } from '@angular/router';

import { routes } from './app.routes';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideLucideIcons } from '@lucide/angular';
import { provideHotToastConfig } from '@ngxpert/hot-toast';
import { networkInterceptor } from './core/Interceptors/network-interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideRouter(routes, withComponentInputBinding() , withInMemoryScrolling(
      {
        scrollPositionRestoration : 'enabled',
        anchorScrolling : 'enabled'
      }
    )),
    provideHttpClient(withInterceptors([networkInterceptor])), 
    provideLucideIcons(),
    provideHotToastConfig({
      position: 'top-center',
      duration: 3000,
    }),
  ],
};
