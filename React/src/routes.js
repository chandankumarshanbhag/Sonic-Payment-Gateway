/*!

=========================================================
* Argon Dashboard React - v1.0.0
=========================================================

* Product Page: https://www.creative-tim.com/product/argon-dashboard-react
* Copyright 2019 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://github.com/creativetimofficial/argon-dashboard-react/blob/master/LICENSE.md)

* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/

import Index from "./views/Index.jsx";
import Profile from "./views/examples/Profile.jsx";
import Maps from "./views/examples/Maps.jsx";
import Register from "./views/examples/Register.jsx";
//import Login from "./views/examples/Login.jsx";
import Tables from "./views/examples/Tables.jsx";
import Icons from "./views/examples/Icons.jsx";


import CreateAccount from "./views/createaccount/CreateAccount";
import AddAmount from "./views/addamount/AddAmount";
import AddAmountView from "./views/addamount/AddAmountView";
import DeleteAccount from "./views/deleteaccount/DeleteAccount"
import UpdateAccount from "./views/updateaccount/updateaccount"
import UpdateAccountView from "./views/updateaccount/updateaccountview"
import Report from "./views/report/report"
import Accounts from "./views/Account/accounts"
import AccountView from "./views/Account/accountview"
import Login from "./views/login/Login";
import AddBankStaff from './views/addbankstaff/addbankstaff';
import Search from './views/Search/Search';

var routes = [
  // {
  //   path: "/index",
  //   name: "Dashboard",
  //   icon: "ni ni-tv-2 text-primary",
  //   component: Index,
  //   layout: "/admin"
  // },

  {
    path: "/createaccount",
    name: "Create Account",
    icon: "ni ni-circle-08 text-primary",
    component: CreateAccount,
    layout: "/admin"
  },
  {
    path: "/account/:id",
    name: "Account",
    icon: "ni ni-circle-08 text-primary",
    component: AccountView,
    layout: "/admin",
    sidebar: false
  },
  {
    path: "/accounts",
    name: "Accounts",
    icon: "ni ni-circle-08 text-primary",
    component: Accounts,
    layout: "/admin"
  },
  {
    path: "/deleteaccount",
    name: "Delete Account",
    icon: "ni ni-fat-remove text-primary",
    component: DeleteAccount,
    layout: "/admin"
  },
  {
    path: "/addamount/:id",
    name: "Add Amount",
    icon: "ni ni-money-coins text-primary",
    component: AddAmountView,
    layout: "/admin",
    sidebar: false
  },
  {
    path: "/addamount",
    name: "Add Amount",
    icon: "ni ni-money-coins text-primary",
    component: AddAmount,
    layout: "/admin"
  },
  {
    path: "/updateaccountview/:id",
    name: "Update Account",
    icon: "ni ni-money-coins text-primary",
    component: UpdateAccountView,
    layout: "/admin",
    sidebar: false
  },
  {
    path: "/updateaccount",
    name: "Update Account",
    icon: "ni ni-money-coins text-primary",
    component: UpdateAccount,
    layout: "/admin"
  },
  {
    path: "/report",
    name: "Report",
    icon: "ni ni-single-copy-04 text-primary",
    component: Report,
    layout: "/admin"
  },
  {
    path: "/search",
    name: "Search",
    icon: "ni ni-zoom-split-in text-primary",
    component: Search,
    layout: "/admin"
  },
  {
    path: "/login",
    name: "Login",
    icon: "ni ni-key-25 text-info",
    component: Login,
    sidebar: false,
    layout: "/auth"
  },
  {
    path: "/addbankstaff",
    name: "Add Bank Staff",
    icon: "ni ni-briefcase-24 text-primary",
    component: AddBankStaff,
    layout: "/admin"
  },

  // {
  //   path: "/icons",
  //   name: "Icons",
  //   icon: "ni ni-planet text-blue",
  //   component: Icons,
  //   layout: "/admin"
  // },
  // {
  //   path: "/maps",
  //   name: "Maps",
  //   icon: "ni ni-pin-3 text-orange",
  //   component: Maps,
  //   layout: "/admin"
  // },
  // {
  //   path: "/user-profile",
  //   name: "User Profile",
  //   icon: "ni ni-single-02 text-yellow",
  //   component: Profile,
  //   layout: "/admin"
  // },
  // {
  //   path: "/tables",
  //   name: "Tables",
  //   icon: "ni ni-bullet-list-67 text-red",
  //   component: Tables,
  //   layout: "/admin"
  // },

  // {
  //   path: "/register",
  //   name: "Register",
  //   icon: "ni ni-circle-08 text-pink",
  //   component: Register,
  //   layout: "/auth"
  // }
];
export default routes;
