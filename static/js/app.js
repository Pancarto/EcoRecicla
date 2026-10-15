// ============================================================
// ECORECICLA - JAVASCRIPT GENERAL (solo interacción visual)
// ============================================================

document.addEventListener("DOMContentLoaded", function () {
    inicializarMenuMovil();
    inicializarMensajesFlash();
    inicializarContadores();
    inicializarRipple();
});

// ------------------------------------------------------------
// MENÚ MÓVIL
// ------------------------------------------------------------

function inicializarMenuMovil() {
    var boton = document.querySelector(".nav-toggle");
    var nav = document.querySelector("header nav");

    if (!boton || !nav) return;

    boton.addEventListener("click", function () {
        var abierto = nav.classList.toggle("abierto");
        boton.classList.toggle("abierto", abierto);
        boton.setAttribute("aria-expanded", abierto ? "true" : "false");
    });

    nav.querySelectorAll("a").forEach(function (enlace) {
        enlace.addEventListener("click", function () {
            nav.classList.remove("abierto");
            boton.classList.remove("abierto");
            boton.setAttribute("aria-expanded", "false");
        });
    });
}

// ------------------------------------------------------------
// MENSAJES FLASH: botón de cerrar + autodesvanecido
// ------------------------------------------------------------

function inicializarMensajesFlash() {
    var mensajes = document.querySelectorAll(".mensaje");

    mensajes.forEach(function (mensaje) {
        var cerrar = document.createElement("button");
        cerrar.className = "mensaje-cerrar";
        cerrar.setAttribute("aria-label", "Cerrar mensaje");
        cerrar.innerHTML = "&times;";
        cerrar.addEventListener("click", function () {
            desvanecer(mensaje);
        });
        mensaje.appendChild(cerrar);

        setTimeout(function () {
            desvanecer(mensaje);
        }, 6000);
    });
}

function desvanecer(elemento) {
    if (!elemento || !elemento.parentNode) return;
    elemento.style.transition = "opacity 0.3s ease, transform 0.3s ease";
    elemento.style.opacity = "0";
    elemento.style.transform = "translateY(-6px)";
    setTimeout(function () {
        if (elemento.parentNode) {
            elemento.parentNode.removeChild(elemento);
        }
    }, 300);
}

// ------------------------------------------------------------
// CONTADOR ANIMADO PARA CIFRAS DEL DASHBOARD (.stat-card strong)
// Anima el número que YA está en el HTML; no agrega datos nuevos.
// ------------------------------------------------------------

function inicializarContadores() {
    var cifras = document.querySelectorAll(".stat-card strong");

    cifras.forEach(function (celda) {
        var textoOriginal = celda.textContent.trim();
        var coincidencia = textoOriginal.match(/[\d.,]+/);

        if (!coincidencia) return;

        var numeroTexto = coincidencia[0].replace(/,/g, "");
        var destino = parseFloat(numeroTexto);

        if (isNaN(destino)) return;

        var sufijo = textoOriginal.slice(coincidencia.index + coincidencia[0].length);
        var prefijo = textoOriginal.slice(0, coincidencia.index);
        var decimales = numeroTexto.includes(".") ? numeroTexto.split(".")[1].length : 0;
        var inicio = 0;
        var duracion = 700;
        var tiempoInicio = null;

        function paso(marca) {
            if (!tiempoInicio) tiempoInicio = marca;
            var avance = Math.min((marca - tiempoInicio) / duracion, 1);
            var valorActual = inicio + (destino - inicio) * avance;
            celda.textContent = prefijo + valorActual.toFixed(decimales) + sufijo;

            if (avance < 1) {
                requestAnimationFrame(paso);
            } else {
                celda.textContent = textoOriginal;
            }
        }

        requestAnimationFrame(paso);
    });
}

// ------------------------------------------------------------
// EFECTO RIPPLE EN BOTONES
// ------------------------------------------------------------

function inicializarRipple() {
    document.addEventListener("click", function (evento) {
        var boton = evento.target.closest("button, .boton");
        if (!boton) return;

        var circulo = document.createElement("span");
        var diametro = Math.max(boton.clientWidth, boton.clientHeight);
        var rect = boton.getBoundingClientRect();

        circulo.className = "ripple";
        circulo.style.width = circulo.style.height = diametro + "px";
        circulo.style.left = (evento.clientX - rect.left - diametro / 2) + "px";
        circulo.style.top = (evento.clientY - rect.top - diametro / 2) + "px";

        boton.appendChild(circulo);

        setTimeout(function () {
            if (circulo.parentNode) circulo.parentNode.removeChild(circulo);
        }, 600);
    });
}
