import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const db = admin.firestore();
const fcm = admin.messaging();


export const sendAprrovalNotification = functions.firestore
  .document('coupons/{couponID}')
  .onUpdate(async snapshot => {
    const old = snapshot.before.data()!;
    const coupon = snapshot.after.data()!;

    if (old.isPending === false && coupon.isPending === true) {
      const querySnapshot = await db
        .collection('users')
        .doc(coupon.ownedBy)
        .collection('tokens')
        .get();

      const documentSnapshot = await db
        .collection('users')
        .doc(coupon.usedBy).get();

      const customer = documentSnapshot.data()!;

      const tokens = querySnapshot.docs.map(snap => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Coupon Aprroval Needed',
          body: `Coupon: ${coupon.code}\nUsed by: ${customer.username}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
          cId: `${snapshot.before.id}`,
          tag: `approval`,
        }
      };
      tokens.forEach(function (value) {
        return fcm.sendToDevice(value, payload);
      });
    };

    return null;


  });


export const sendCouponNotification = functions.firestore
  .document('coupons/{couponID}')
  .onUpdate(async snapshot => {

    const old = snapshot.before.data()!;
    const coupon = snapshot.after.data()!;

    if (old.isUsed === false && coupon.isUsed === true) {
      const querySnapshot = await db
        .collection('users')
        .doc(coupon.usedBy)
        .collection('tokens')
        .get();

      const documentSnapshot = await db
        .collection('users')
        .doc(coupon.ownedBy).get();

      const merchant = documentSnapshot.data()!;

      const tokens = querySnapshot.docs.map(snap => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Coupon Aprroved',
          body: `The coupon ${coupon.code} has been approved by ${merchant.username}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
          cId: `${snapshot.before.id}`,
          tag: `updateNotify`,

        }

      };
      tokens.forEach(function (value) {
         fcm.sendToDevice(value, payload);
      });
      return coupon;
    };

    return null;
  });

export const approveCoupon = functions.https.onCall(async (data, context) => {
  try {
    const couponID = data.couponID;
    const coupon = await db
      .collection('coupons').doc(couponID).update({
        'isUsed': true,
        'isPending': false,
      });

    return coupon;
  } catch (error) {
    console.log("error");
    return null;
  }
});

export const markFavorite = functions.https.onCall(async (data, context) => {
  try {
    const merchantId = data.merchantId;
    const customerId = data.customerId;
    const time = data.time;
    let addDoc = db.collection('users').doc(customerId).collection('favorites').doc(merchantId).set({ "time": time });

    const querySnapshot = await db
      .collection('users')
      .doc(customerId)
      .collection('tokens')
      .get();

    const documentSnapshot = await db
      .collection('users')
      .doc(merchantId).get();
    const merchant = documentSnapshot.data()!;

    const strings = merchant.email.split("@");
    const topic = strings[0];
    const tokens = querySnapshot.docs.map(snap => snap.id);
    admin.messaging().subscribeToTopic(tokens, topic)
      .then(function (response) {
        console.log('Successfully subscribed to topic:', response);
      })
      .catch(function (error) {
        console.log('Error subscribing to topic:', error);
      });


    return addDoc;
  } catch (error) {
    console.log("error");
    return null;
  }

});
export const unmarkFavorite = functions.https.onCall(async (data, context) => {
  try {
    const merchantId = data.merchantId;
    const customerId = data.customerId;
    const dr = await db.collection('users').doc(customerId).collection('favorites').doc(merchantId);
    const querySnapshot = await db
      .collection('users')
      .doc(customerId)
      .collection('tokens')
      .get();
    db.runTransaction(t => {
      return t.get(dr)
        .then(doc => {
          t.delete(dr);
        });
    }).then(result => {
      console.log('Transaction success!');
    }).catch(err => {
      console.log('Transaction failure:', err);
    });

    const documentSnapshot = await db
      .collection('users')
      .doc(merchantId).get();
    const merchant = documentSnapshot.data()!;


    const strings = merchant.email.split("@");
    const topic = strings[0];
    const tokens = querySnapshot.docs.map(snap => snap.id);
    admin.messaging().unsubscribeFromTopic(tokens, topic)
      .then(function (response) {
        console.log('Successfully unsubscribed from topic:', response);
      })
      .catch(function (error) {
        console.log('Error unsubscribing from topic:', error);
      });


  } catch (error) {
    console.log("error");

  }
  
});

export const sendNewCouponNotification = functions.firestore
  .document('coupons/{couponID}')
  .onCreate(async snapshot => {

    const coupon = snapshot.data()!;

    if (coupon !== null) {

      const documentSnapshot = await db
        .collection('users')
        .doc(coupon.ownedBy).get();

      const merchant = documentSnapshot.data()!;
      const strings = merchant.email.split("@");
      const topic = strings[0];


      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'A Wild Coupon Appeared!',
          body: `Coupon: ${coupon.code}\nCreated By: ${merchant.username}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
          cId: `${snapshot.id}`,
          tag: `newCoupon`,
        }
      };

      return fcm.sendToTopic(topic, payload);

    };

    return null;


  });