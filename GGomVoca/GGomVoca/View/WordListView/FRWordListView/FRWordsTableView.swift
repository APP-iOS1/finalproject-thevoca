
import SwiftUI
import Foundation

struct FRWordsTableView: View {
    // MARK: Super View Properties
    var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [UUID]
    @Binding var selectedWord: Word
    @Binding var filteredWords: [Word]
    
    // MARK: View Properies
    @Environment(\.dismiss) private var dismiss
    var backgroundColor: Color = Color("background")
    
    
    @Environment(\.managedObjectContext) private var viewContext

    
    var body: some View {
        GeometryReader { geo in
            VStack {
                List {
                    ForEach(filteredWords) { word in
                        ZStack {
                            Rectangle()
                                .fill(backgroundColor)
                            VStack {
                                HStack {
                                    Text(word.word ?? "")
                                        .alignmentGuide(
                                            .listRowSeparatorLeading
                                        ) { dimensions in
                                            dimensions[.leading]
                                        }
                                        .frame(width: geo.size.width * 0.5, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id!)) ? 0 : 1)
                                    
                                    HStack {
                                        Image(systemName: word.option == "f" ? "f.square" : "m.square")
                                            .font(.subheadline)
                                            .opacity(0.5)
                                        Text(word.meaning ?? "")
                                    }
                                    .frame(width: geo.size.width * 0.5, alignment: .center)
                                    .multilineTextAlignment(.center)
                                    .opacity((selectedSegment == .meaningTest && !unmaskedWords.contains(word.id!)) ? 0 : 1)
                                    
                                }
                            }
                        }
                        .contextMenu(ContextMenu {
                            if selectedSegment == .normal {
                                Button {
                                    selectedWord = word
                                    dismiss()
                                } label: {
                                    Label("수정하기", systemImage: "gearshape.fill")
                                }
                                
                                Button {
                                    // Voice Over
                                } label: {
                                    Label("발음 듣기", systemImage: "mic.fill")
                                }
                            }
                            
                        })
                        .listRowBackground(backgroundColor)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if unmaskedWords.contains(word.id!) {
                                if let tmpIndex = unmaskedWords.firstIndex(of: word.id!) {
                                    unmaskedWords.remove(at: tmpIndex)
                                }
                            } else {
                                unmaskedWords.append(word.id!)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                word.deletedAt = "\(Date())"
                                print("현재 시간 데이터를 deleteAt prop에 update \(word.deletedAt!)")
                                // filteredWords에서는 진짜로 제거
//                                if let index = filteredWords.firstIndex(of: word) {
//                                    print("\(index)")
//                                    filteredWords.remove(at: index)
//                                }
//                                try? viewContext.save()
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                .navigationBarItems(trailing: EditButton())
                .refreshable {
                    print("refresh")
                }
                .listStyle(.plain)
            }
            
        }
    }
}
