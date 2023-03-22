<template>
  <div class="cart-container">
  
    <div class="cart-header">
    <img alt="Master da Web" src="./assets/master.png" width="300" >
      <h1>Lista de Produtos</h1>
      <p>Escolha uma das opções abaixo:</p>
      <div class="product-list">
        <div v-for="product in products" :key="product.id">
          <div>{{ product.title }}</div>
          <div>R$ {{ product.price }}</div>
          <button @click="addToCart(product)" class="add-to-cart-button">+</button>
        </div>
      </div>
    </div>
    <div class="cart-summary">
      <h2>Checkout:</h2>
      <div class="cart-items">
        <div v-for="(item, index) in cartItems" :key="index">
          <div>{{ item.product.title }} ({{ item.quantity }})</div>
          <button @click="removeFromCart(index)" class="add-to-cart-button">X</button>
        </div>
      </div>
      <div class="cart-total">
        <h3>Total: R$ {{ cartTotal }}</h3>
        <button @click="checkout()" :disabled="cartItems.length === 0" class="checkout-button" :class="{'disabled-button': isCartEmpty}">Fechar pedido</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      products: [],
      cartItems: [],
      isCartEmpty: true,
    };
  },
  created() {
    this.fetchProducts();
  },
  methods: {
    fetchProducts() {
      axios.get('http://localhost:8000/cart/products')
        .then(response => {
          this.products = response.data;
        })
        .catch(error => {
          console.log(error);
        });
    },
    addToCart(product) {
      const itemIndex = this.cartItems.findIndex(item => item.product.id === product.id);
      if (itemIndex !== -1) {
        this.cartItems[itemIndex].quantity++;
      } else {
        this.cartItems.push({ product, quantity: 1 });
      }
      this.isCartEmpty = false; // atualizando o valor de isCartEmpty
    },
    removeFromCart(index) {
      this.cartItems.splice(index, 1);
      this.isCartEmpty = this.cartItems.length === 0; // atualizando o valor de isCartEmpty
    },
    checkout() {
      const items = this.cartItems.map(item => ({
        id: item.product.id,
        title: item.product.title,
        price: item.product.price,
        quantity: item.quantity,
      }));
      const data = { items };
      axios.post('http://localhost:8000/cart/checkout', data, {
          headers: {
            'Content-Type': 'application/json',
          },
        })
        .then(response => {
          console.log(response);
          this.cartItems = [];
          this.isCartEmpty = true;        
        })
        .catch(error => {
          console.log(error);
        });
    },
  },
  computed: {
    cartTotal() {
      return this.cartItems.reduce((total, item) => total + (item.product.price * item.quantity), 0);
    },
  },
};
</script>

<style>
.cart-container {
  background-color: #9966cc;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.cart-header,
.cart-summary {
  background-color: white;
  padding: 20px;
  margin: 20px;
  border-radius: 5px;
}

.cart-summary {
  text-align: center;
}

.product-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
grid-gap: 20px;
}

.product-list > div {
background-color: #f5f5f5;
padding: 10px;
display: flex;
flex-direction: column;
justify-content: space-between;
border-radius: 5px;
}

.product-list > div > div:first-child {
font-weight: bold;
font-size: 1.2rem;
}

.product-list > div > div:last-child {
margin-top: 10px;
font-weight: bold;
font-size: 1.2rem;
}

.cart-items {
display: flex;
flex-direction: column;
margin-top: 20px;
}

.cart-items > div {
display: flex;
justify-content: space-between;
align-items: center;
padding: 10px;
background-color: #f5f5f5;
margin-bottom: 10px;
border-radius: 5px;
}

.cart-items > div > button {
background-color: #FF0000;
  color: white;
  font-size: 1rem;
  font-weight: bold;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
  width:30px;
}

.cart-total {
margin-top: 20px;
}

.cart-total > h3 {
font-weight: bold;
font-size: 2rem;
}

.checkout-button {
background-color: #9966cc;
color: white;
border: none;
padding: 10px;
border-radius: 5px;
font-weight: bold;
font-size: 1.2rem;
cursor: pointer;
margin-top: 10px;
}

.add-to-cart-button {
  background-color: #9966cc;
  color: white;
  font-size: 1rem;
  font-weight: bold;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
  width:30px;
}

.disabled-button {
  background-color: #cccccc;
  color: white;
  border: none;
  padding: 10px;
  border-radius: 5px;
  font-weight: bold;
  font-size: 1.2rem;
  cursor: pointer;
  margin-top: 10px;
}


</style>
