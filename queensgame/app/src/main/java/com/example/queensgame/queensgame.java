package com.example.queensgame;
import java.util.*;

public class queensgame {

    private static final int GRID_SIZE = 9; // 9x9'lik bir oyun tahtası
    private int[][] board = new int[GRID_SIZE][GRID_SIZE]; // 0: boş, 1: çarpı, 2: taç
    private List<int[][]> templates = new ArrayList<>(); // Renk şablonları
    private int currentTemplateIndex = 0; // Geçerli şablon indeksi
    private boolean gameWon = false; // Oyunun kazanılıp kazanılmadığını takip et
    private int gameTemplateIndex = 0;

    // Map verileri (Renk şablonları)
    private List<Map<String, Object>> maps = new ArrayList<>();

    public queensgame() {
        loadMaps(); // Renk şablonlarını yükle
    }

    private void loadMaps() {
        // Map verileri örnek olarak burada yükleniyor
        maps.add(new HashMap<String, Object>() {{
            put("name", "Map n° 21");
            put("caseNumber", 9);
            put("colorGrid", new int[][] {
                    {2, 0, 1, 1, 1, 1, 1, 1, 1},
                    {2, 2, 2, 1, 1, 1, 1, 3, 3},
                    {4, 2, 2, 1, 1, 1, 3, 3, 3},
                    {4, 4, 4, 4, 3, 3, 3, 3, 3},
                    {6, 6, 6, 4, 4, 3, 3, 3, 5},
                    {6, 6, 6, 4, 4, 3, 3, 5, 5},
                    {6, 6, 6, 8, 8, 3, 3, 5, 5},
                    {6, 8, 8, 8, 8, 8, 8, 7, 5},
                    {6, 8, 8, 8, 8, 8, 8, 8, 5}
            });
        }});

        // Diğer harita verilerini de burada yükleyebilirsiniz.
    }

    private void loadTemplates() {
        for (Map<String, Object> map : maps) {
            int[][] colorGrid = (int[][]) map.get("colorGrid");
            int[][] templateColors = new int[GRID_SIZE][GRID_SIZE];
            for (int i = 0; i < GRID_SIZE; i++) {
                for (int j = 0; j < GRID_SIZE; j++) {
                    switch (colorGrid[i][j]) {
                        case 0: templateColors[i][j] = 0; break;
                        case 1: templateColors[i][j] = 1; break;
                        case 2: templateColors[i][j] = 2; break;
                        case 3: templateColors[i][j] = 3; break;
                        case 4: templateColors[i][j] = 4; break;
                        case 5: templateColors[i][j] = 5; break;
                        case 6: templateColors[i][j] = 6; break;
                        case 7: templateColors[i][j] = 7; break;
                        default: templateColors[i][j] = 8; break;
                    }
                }
            }
            templates.add(templateColors);
        }
    }

    private boolean isInvalidStarPosition(int row, int col) {
        boolean control = true;
        // Aynı satırda veya sütunda başka taç var mı kontrolü
        for (int i = 0; i < GRID_SIZE; i++) {
            if ((i != col && board[row][i] == 2) || (i != row && board[i][col] == 2)) {
                control = false;
                return true;
            }
        }

        // Komşu karelerde başka taç var mı kontrolü
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                int newRow = row + i;
                int newCol = col + j;
                if (newRow >= 0 && newRow < GRID_SIZE && newCol >= 0 && newCol < GRID_SIZE &&
                        !(i == 0 && j == 0) && board[newRow][newCol] == 2) {
                    control = false;
                    return true;
                }
            }
        }

        // Aynı renk bloğunda başka taç var mı kontrolü
        int color = ((int[][]) maps.get(gameTemplateIndex).get("colorGrid"))[row][col];
        if (color == 0) {
            return true; // Geçerli bir yıldız yerleşimi değil
        }

        for (int r = 0; r < GRID_SIZE; r++) {
            for (int c = 0; c < GRID_SIZE; c++) {
                if (((int[][]) maps.get(gameTemplateIndex).get("colorGrid"))[r][c] == color &&
                        board[r][c] == 2 && (r != row || c != col)) {
                    control = false;
                    return true;
                }
            }
        }

        return false;
    }

    private void checkWinCondition() {
        Set<String> queensInRows = new HashSet<>();
        Set<String> queensInColumns = new HashSet<>();
        Set<Integer> uniqueColors = new HashSet<>();
        boolean hasInvalidPosition = false;

        for (int row = 0; row < GRID_SIZE; row++) {
            for (int col = 0; col < GRID_SIZE; col++) {
                if (board[row][col] == 2) { // Eğer hücrede taç varsa
                    queensInRows.add("row" + row);
                    queensInColumns.add("col" + col);
                    uniqueColors.add(templates.get(currentTemplateIndex)[row][col]);

                    // Hatalı pozisyon kontrolü
                    if (isInvalidStarPosition(row, col)) {
                        hasInvalidPosition = true;
                    }
                }
            }
        }

        // Kazanma durumu
        if (queensInRows.size() == GRID_SIZE &&
                queensInColumns.size() == GRID_SIZE &&
                uniqueColors.size() == GRID_SIZE &&
                !hasInvalidPosition) {
            gameWon = true;
            System.out.println("Oyunu kazandınız!");
        }
    }

    private void resetGame() {
        board = new int[GRID_SIZE][GRID_SIZE]; // Oyunu sıfırla
        gameWon = false; // Kazanma durumunu sıfırla
    }

    private void nextTemplate() {
        currentTemplateIndex = (currentTemplateIndex + 1) % templates.size(); // Sonraki şablona geç
        gameTemplateIndex = (gameTemplateIndex + 1) % maps.size();
        resetGame(); // Oyunu sıfırla
    }

    private void previousTemplate() {
        currentTemplateIndex = (currentTemplateIndex - 1 + templates.size()) % templates.size(); // Önceki şablona geç
        gameTemplateIndex = (gameTemplateIndex - 1 + maps.size()) % maps.size();
        resetGame(); // Oyunu sıfırla
    }

    public static void main(String[] args) {
        queensgame game = new queensgame();
        game.loadTemplates(); // Renk şablonlarını yükle
        // Oyun başlatma ve yönetme kodu buraya eklenebilir.
    }
}
