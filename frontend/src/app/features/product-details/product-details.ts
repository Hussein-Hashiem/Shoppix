import { Component, computed, effect, inject, input, OnInit, output, signal } from '@angular/core';
import { ProductDetailsService } from '../../core/services/product-details.service';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { HotToastService } from '@ngxpert/hot-toast';
import { LucideArrowLeft, LucideArrowRight, LucideHouse, LucideMinus, LucidePlus, LucideShoppingCartPlus } from '@lucide/angular';
import { CartService } from '../../core/services/cart.service';
import { ProductModel } from '../../core/models/product.model';
import { ProductCard } from '../../shared/components/product-card/product-card';

@Component({
  imports: [RouterLink, ProductCard, LucideHouse, LucideShoppingCartPlus, LucidePlus, LucideMinus],
  selector: 'app-product-details',
  styleUrl: './product-details.css',
  templateUrl: './product-details.html',
})
export class ProductDetails implements OnInit {
  // Injections
  productDetailsService = inject(ProductDetailsService);
  cartService = inject(CartService);
  toast = inject(HotToastService);
  route = inject(ActivatedRoute);

  id = signal<number>(1);
  prodDetails = signal<ProductModel | null>(null);
  relatedProds = signal<ProductModel[] | null>(null);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);
  amount = signal<number>(1);
  AddToCart = output<boolean>();

  constructor() {
    this.route.paramMap.subscribe((params) => {
      let id = 1;
      if (params.get('id')) {
        id = +params.get('id')!;
      } else {
        id = 1;
      }
      this.id.set(id);
    }
    )
  }
  ngOnInit() {
    this.loadProduct();
    this.loadRelated();
  }

  loadProduct() {
    this.isLoading.set(true);
    this.hasError.set(false);

    this.productDetailsService.getProductById(this.id()).subscribe({
      next: (prod) => {
        this.prodDetails.set(prod);
        this.isLoading.set(false);
      },
      error: (err) => {
        console.error('Error loading product details:', err);
        this.isLoading.set(false);
        this.hasError.set(true);
      }
    })
  }

  loadRelated() {
    this.isLoading.set(true);
    this.hasError.set(false);

    this.productDetailsService.getRelatedProducts(this.id()).subscribe({
      next: (prods) => {
        this.relatedProds.set(prods);
        this.isLoading.set(false);
      },
      error: (err) => {
        console.error('Error loading product details:', err);
        this.isLoading.set(false);
        this.hasError.set(true);
      }
    })
  }

  isOutOfStock = computed(() => {
    const product = this.prodDetails();
    if (!product) return true;

    const cartItem = this.cartService.cartItems().find(item => item.id === product.id);
    const currentQuantityInCart = cartItem ? cartItem.quantity : 0;
    return currentQuantityInCart >= product.stockQuantity;
  });

  onAddToCart() {
    const product = this.prodDetails();
    if (!product) return;

    const isSuccess = this.cartService.addToCart(product, this.amount());

    if (isSuccess) {
      this.toast.success('Product added to cart successfully!');
    } else {
      this.toast.error('Failed to add product to cart. Stock limit reached.');
    }
  }

  changeAmount(am: number) {
    console.log(this.amount());

    this.amount.update((crAm) => {
      return crAm += am;
    })
  }

  productCartQuantity = computed(() => {
    const currentProd = this.prodDetails();
    if (!currentProd) return 0;

    const item = this.cartService.cartItems().find((item) => item.id === currentProd.id);
    return item ? item.quantity : 0;
  });

  addToCart(isSuccess: boolean): void {
    if (isSuccess) {
      this.toast.success('Product added to cart successfully!');
    } else {
      this.toast.error('Failed to add product to cart. Stock limit reached.');
    }
  }
}
