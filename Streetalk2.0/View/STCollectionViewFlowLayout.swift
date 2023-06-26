//
//  STCollectionViewFlowLayout.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // 아래의 로직들은 STHomeViewController의 헤더뷰 배너를 Stretchable 형태로 구현하기 위한 코드
    // ref. https://medium.com/@Anantha1992/stretchable-header-view-in-uicollectionview-swift-5-ios-a14a25dcd383
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
            return layoutAttributes
        }
        if offset.y < 0 {
            
            for attributes in stLayoutAttributes {
                
                if let elmKind = attributes.representedElementKind, elmKind == UICollectionView.elementKindSectionHeader {
                    
                    let diffValue = abs(offset.y)
                    var frame = attributes.frame
                    frame.size.height = max(0, headerReferenceSize.height + diffValue)
                    frame.origin.y = frame.minY - diffValue
                    attributes.frame = frame
                }
            }
        }
        return layoutAttributes
    }
    
}
