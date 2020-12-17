import * as firebase from "firebase/app";
import "firebase/analytics";
import "firebase/auth";
import "firebase/firestore";
import "firebase/database";
import "firebase/storage";
import "firebase/messaging";
const firebaseConfig = {
  // Firebase config
};
export default firebase.initializeApp(firebaseConfig);

