importScripts('https://www.gstatic.com/firebasejs/9.1.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.2/firebase-messaging.js');

firebase.initializeApp({
  apiKey: "AIzaSyDAAgHVCFP6R-uoY49EccuZhPtVoEhjU40",
  authDomain: "honoursproject-4100c.firebaseapp.com",
  projectId: "honoursproject-4100c",
  storageBucket: "honoursproject-4100c.firebasestorage.app",
  messagingSenderId: "375762163417",
  appId: "1:375762163417:web:64e1ec057ddbbf239fd0c8",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});