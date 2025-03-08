package com.example.queensgame;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private static final int GRID_SIZE = 9; // 9x9'luk grid
    private int[][] board = new int[GRID_SIZE][GRID_SIZE]; // 0: boş, 1: çarpı, 2: taç
    private GridView gridView;
    private BoardAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        gridView = findViewById(R.id.gridView);
        adapter = new BoardAdapter();
        gridView.setAdapter(adapter);

        gridView.setOnItemClickListener((parent, view, position, id) -> {
            int row = position / GRID_SIZE;
            int col = position % GRID_SIZE;

            // Taç ekleme işlemi
            if (board[row][col] == 0) {
                board[row][col] = 2; // 👑 koy
            } else {
                board[row][col] = 0; // Boşalt
            }

            adapter.notifyDataSetChanged(); // UI'yi güncelle
        });
    }

    // GridView için özel bir Adapter
    private class BoardAdapter extends BaseAdapter {
        @Override
        public int getCount() {
            return GRID_SIZE * GRID_SIZE;
        }

        @Override
        public Object getItem(int position) {
            int row = position / GRID_SIZE;
            int col = position % GRID_SIZE;
            return board[row][col];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            TextView textView;

            if (convertView == null) {
                textView = new TextView(MainActivity.this);
                textView.setTextSize(24);
                textView.setGravity(android.view.Gravity.CENTER);
                textView.setLayoutParams(new GridView.LayoutParams(100, 100));
            } else {
                textView = (TextView) convertView;
            }

            int row = position / GRID_SIZE;
            int col = position % GRID_SIZE;

            if (board[row][col] == 2) {
                textView.setText("👑"); // Taç
            } else {
                textView.setText(""); // Boş hücre
            }

            return textView;
        }
    }
}
