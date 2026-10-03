import { ProductCard } from './../../shared/components/product-card/product-card';
import { Component, inject, OnInit, signal } from '@angular/core';
import { ProductModel } from '../../core/models/product.model';
import { LucideMoveRight } from '@lucide/angular';
import { CommonModule } from '@angular/common';
import { ProductCardSkeleton } from '../../shared/components/product-card-skeleton/product-card-skeleton';
import { ProductsService } from '../../core/services/products.service';
import { ActivatedRoute, Router } from '@angular/router';
import { HotToastService } from '@ngxpert/hot-toast';

@Component({
  imports: [CommonModule, LucideMoveRight, ProductCard, ProductCardSkeleton],
  selector: 'app-home',
  styleUrl: './home.css',
  templateUrl: './home.html',
})
export class Home implements OnInit {
  math = Math;
  // Injections 
  productsService = inject(ProductsService);
  router = inject(Router);
  route = inject(ActivatedRoute);
  toast = inject(HotToastService);

  allproducts = signal<ProductModel[]>([]);
  currentProducts = signal<ProductModel[]>([]);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);

  // pagination varibales
  currentPage = signal<number>(1);
  totalPages = signal<number>(1);
  pageSize: number = 12;


  ngOnInit() {
    this.loadProducts();
  }

  loadProducts() {
    this.productsService.getProducts().subscribe({
      next: (products) => {
        this.allproducts.set(products);
        this.isLoading.set(false);
        this.totalPages.set(this.getPagesCount(products.length));

        this.route.queryParams.subscribe((params) => {
          const queryPage = parseInt(params['page']);
          const page = !isNaN(queryPage) && queryPage > 0 ? queryPage : 1;
          this.currentPage.set(page);
          if (this.allproducts().length > 0) {
            this.updateProductsView(page);
          }
        })
      },
      error: (error) => {
        console.error('Error loading products:', error);
        this.isLoading.set(false);
        this.hasError.set(true);
      }
    });
  }

  getPagesCount(productNumber: number): number {
    return Math.ceil(productNumber / this.pageSize);
  }

  updateProductsView(page: number): void {
    this.currentPage.set(page);
    const startIndex = (page - 1) * this.pageSize;
    const endIndex = startIndex + this.pageSize;
    this.currentProducts.set(this.allproducts().slice(startIndex, endIndex));
  }

  updateCurrentProducts(page : number ):void{
    this.router.navigate([],{
      relativeTo: this.route,
      queryParams : {page : page},
      queryParamsHandling : 'merge'
    })
  }

  getPaginationNumbers(): (number | string)[] {
    const totalPages = this.totalPages();
    const currentPage = this.currentPage();

    if (totalPages <= 5) {
      return Array.from({ length: totalPages }, (_, i) => i + 1);
    }

    const pages: (number | string)[] = [];

    if (currentPage < 3) {
      pages.push(1, 2, 3, '...', totalPages);
    } else if (currentPage > totalPages - 2) {
      pages.push(1, '...', totalPages - 2, totalPages - 1, totalPages);
    } else {
      pages.push(1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages);
    }
    return pages;
  }

  addToCart(isSuccess: boolean): void {
        if(isSuccess){
          this.toast.success('Product added to cart successfully!');
        }else{
          this.toast.error('Failed to add product to cart. Stock limit reached.');
        }
  }
}
