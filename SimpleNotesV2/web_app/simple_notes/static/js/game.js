let field = new Array(9);
let steps = 0;

// because chrome alert faster then .style change
const delay_alert = (message) => {
    setTimeout(() => alert(message), 50);
}

for (let i = 0; i < 9; i++) {
    field[i] = i;
    let cell = document.getElementById('c' + i)
    cell.addEventListener('click', () => {
        if (! is_end()) {
            let res = player_step(i);
            if (! is_end()) {
                if (res) bot_step();
            } else {
                delay_alert('game ends');
            }
        } else {
            delay_alert('game ends');
        }
    });
}

const bot_step = () => {
    let cell_id = Math.round(Math.random() * (8 - 0) + 0);
    if (field[cell_id] === 'X' || field[cell_id] === 'O') {
        bot_step();
    } else {
        field[cell_id] = 'O';
        let cell = document.getElementById('c' + cell_id);
        cell.style.background = 'green';
        cell.textContent = 'O';
        steps++;
    }
};

const player_step = (cell_id) => {
    if (field[cell_id] !== 'X' && field[cell_id] !== 'O') {
        field[cell_id] = 'X';
        let cell = document.getElementById('c' + cell_id);
        cell.style.background = 'red';
        cell.textContent = 'X';
        steps++;
        return true;
    }
    return false;
};


const is_end = () => {
    if (field[0] === field[1] && field[1] === field[2]) return true;
    if (field[3] === field[4] && field[4] === field[5]) return true;
    if (field[6] === field[7] && field[7] === field[8]) return true;
    if (field[0] === field[3] && field[3] === field[6]) return true;
    if (field[1] === field[4] && field[4] === field[7]) return true;
    if (field[2] === field[5] && field[5] === field[8]) return true;
    if (field[0] === field[4] && field[4] === field[8]) return true;
    if (field[2] === field[4] && field[4] === field[6]) return true;
    if (steps === 9) return true;
    return false;
};