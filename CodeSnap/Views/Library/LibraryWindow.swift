//
//  LibraryWindow.swift
//  CodeSnap
//
//  Screenshot library window
//

import SwiftUI
import AppKit

class LibraryWindow {
    private var window: NSWindow?

    func show() {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            return
        }

        let contentView = LibraryView()
        let hostingController = NSHostingController(rootView: contentView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: Constants.UI.libraryWidth, height: Constants.UI.libraryHeight),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window.title = "CodeSnap Library"
        window.contentViewController = hostingController
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false

        self.window = window
    }

    func close() {
        window?.close()
    }
}

// MARK: - Library View

struct LibraryView: View {
    @State private var screenshots: [Screenshot] = []
    @State private var searchText = ""
    @State private var selectedLanguage: String?
    @State private var viewMode: LibraryViewMode = .grid
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            toolbar

            Divider()

            // Content
            if isLoading {
                ProgressView("Loading library...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredScreenshots.isEmpty {
                emptyState
            } else {
                if viewMode == .grid {
                    gridView
                } else {
                    listView
                }
            }
        }
        .onAppear {
            loadScreenshots()
        }
    }

    private var toolbar: some View {
        HStack {
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search library...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .frame(maxWidth: 300)

            Spacer()

            // View mode
            Picker("View", selection: $viewMode) {
                Image(systemName: "square.grid.2x2").tag(LibraryViewMode.grid)
                Image(systemName: "list.bullet").tag(LibraryViewMode.list)
            }
            .pickerStyle(.segmented)
            .frame(width: 100)
        }
        .padding()
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 180, maximum: 200), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredScreenshots) { screenshot in
                    ScreenshotGridItem(screenshot: screenshot)
                }
            }
            .padding()
        }
    }

    private var listView: some View {
        List(filteredScreenshots) { screenshot in
            ScreenshotListItem(screenshot: screenshot)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No Screenshots")
                .font(.title2)

            Text("Create your first beautiful code screenshot")
                .foregroundColor(.secondary)

            Button("New Screenshot") {
                // Trigger quick capture
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var filteredScreenshots: [Screenshot] {
        screenshots.filter { screenshot in
            let matchesSearch = searchText.isEmpty ||
                screenshot.code.localizedCaseInsensitiveContains(searchText) ||
                screenshot.language.localizedCaseInsensitiveContains(searchText)

            let matchesLanguage = selectedLanguage == nil ||
                screenshot.language == selectedLanguage

            return matchesSearch && matchesLanguage
        }
    }

    private func loadScreenshots() {
        isLoading = true

        Task {
            if let loaded = try? StorageManager.shared.loadScreenshots() {
                await MainActor.run {
                    screenshots = loaded
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Grid Item

struct ScreenshotGridItem: View {
    let screenshot: Screenshot

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.2))
                .frame(height: 140)
                .overlay(
                    VStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)

                        Text(screenshot.language)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )

            // Info
            Text(screenshot.firstTwoLines)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(2)
                .foregroundColor(.primary)

            HStack {
                Text(screenshot.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Spacer()

                if screenshot.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - List Item

struct ScreenshotListItem: View {
    let screenshot: Screenshot

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 80, height: 50)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(screenshot.language)
                    .font(.headline)

                Text(screenshot.firstTwoLines)
                    .font(.system(.caption, design: .monospaced))
                    .lineLimit(1)
                    .foregroundColor(.secondary)

                Text(screenshot.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if screenshot.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}
