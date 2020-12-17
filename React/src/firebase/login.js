export function login(user) {
    localStorage.setItem("login", JSON.stringify(user))
    return true
}

export function checkLogin() {
    let login = localStorage.getItem("login")
    return login ? true : false
}

export function getUser() {
    try {
        return JSON.parse(localStorage.getItem("login"))
    }
    catch (e) {
        return null;
    }
}

export function logout(user) {
    localStorage.removeItem("login")
    return true
}