// قم باستيراد Firebase SDK
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// قم بتهيئة Firebase في الـ Service Worker
const firebaseConfig = {
    apiKey: "AIzaSyAT_hWzzm6EihhyU2uZdZTaSWcsyj-I5y0",
    authDomain: "ecommerce-app-6a8cc.firebaseapp.com",
    projectId: "ecommerce-app-6a8cc",
    storageBucket: "ecommerce-app-6a8cc.firebasestorage.app",
    messagingSenderId: "486269813863",
    appId: "1:486269813863:web:41cbd85b1549241fe480c2"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();