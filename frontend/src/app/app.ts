import { Component, OnInit, signal } from '@angular/core';
<<<<<<< HEAD
=======
import { Footer } from './shared/components/footer/footer';
>>>>>>> affc364ff2fc9f57e09cdc2ca15fa1840123922a
import { RouterOutlet } from '@angular/router';
import { initFlowbite } from 'flowbite';
import { Navbar } from './shared/components/navbar/navbar';

@Component({
  selector: 'app-root',
<<<<<<< HEAD
  imports: [RouterOutlet, Navbar],
=======
  imports: [RouterOutlet, Footer , Navbar],
>>>>>>> affc364ff2fc9f57e09cdc2ca15fa1840123922a
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  protected readonly title = signal('Shoppix');

  ngOnInit(): void {
    initFlowbite();
  }
}
