//
//  PDF.swift
//  EFB
//
//  Created by Jonathan Lim on 11/9/25.
//

import SwiftUI
import PDFKit

struct PDFViewRepresentable: UIViewRepresentable {
    let pdfView = PDFView()
    let data: Data
    init(
        data: Data,
        autoScales: Bool = true,
        usePageViewController: Bool = false,
        backgroundColor: UIColor = .prm,
        displayDirection: PDFDisplayDirection = .vertical,
        pageBreakMargins: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    ) {
        
        pdfView.autoScales = autoScales
        pdfView.usePageViewController(usePageViewController)
        pdfView.backgroundColor = backgroundColor
        pdfView.displayDirection = displayDirection
        pdfView.pageBreakMargins = pageBreakMargins
        
        self.data = data
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfDocument = PDFDocument(data: data)
        pdfView.document = pdfDocument
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) { }
   
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PDFViewRepresentable
        
        init(_ parent: PDFViewRepresentable) {
            self.parent = parent
        }
    }
}

struct DrawingOverlay: View {
    @Binding var paths: [Path]
    
    var body: some View {
        Canvas { context, size in
            for path in paths {
                context.stroke(path, with: .color(.red), lineWidth: 3)
            }
        }
        .allowsHitTesting(false)
    }
}
