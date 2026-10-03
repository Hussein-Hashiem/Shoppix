import { Component, OnInit, signal } from '@angular/core';
import { Footer } from './shared/components/footer/footer';
import { RouterOutlet } from '@angular/router';
import { initFlowbite } from 'flowbite';
import { Navbar } from './shared/components/navbar/navbar';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Footer , Navbar],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  protected readonly title = signal('Shoppix');

  ngOnInit(): void {
    initFlowbite();
  }
}
