const loginBtn = document.querySelector("button")

loginBtn.onclick = function() {
  localStorage.setItem("name", "localStorage")
  sessionStorage.setItem("name", "sessionStorage")
}
