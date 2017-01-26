-- Export Google Analytics BigQuery data using standard SQL
--
-- Keep the #standardSQL comment on your query to instruct BigQuery to use standard SQL (BigQuery dialect)
-- Authors:     Joao Correia <joao.correia@gmail.com>
-- License:     Apache License Version 2.0

#standardSQL
SELECT
  -- Hits are recorded in UTC. Customize your timezone to convert to your timezone.
  FORMAT_TIMESTAMP("%Y-%m-%d %H:%M:%S", TIMESTAMP_SECONDS(SAFE_CAST(visitStartTime+hits.time/1000 AS INT64)), "America/Los_Angeles") AS hit_timestamp,
  visitNumber,
  visitId,
  fullVisitorId,
  FORMAT_TIMESTAMP("%Y-%m-%d %H:%M:%S", TIMESTAMP_SECONDS(SAFE_CAST(visitStartTime AS INT64)), "America/Los_Angeles") AS hit_visitStartTime,
  CONCAT(SUBSTR(date,0,4),"-",SUBSTR(date,5,2),"-",SUBSTR(date,7,2)) AS date,
  trafficSource.referralPath,
  trafficSource.campaign,
  trafficSource.source,
  trafficSource.medium,
  trafficSource.keyword,
  trafficSource.adContent,
  device.browser,
  device.browserVersion,
  device.operatingSystem,
  device.operatingSystemVersion,
  device.isMobile,
  device.mobileDeviceBranding, /* Only Availabe is later schemas */
  device.flashVersion,
  device.javaEnabled,
  device.language,
  device.screenColors,
  device.screenResolution,
  device.deviceCategory,
  geoNetwork.continent,
  geoNetwork.subContinent,
  geoNetwork.country,
  geoNetwork.region,
  geoNetwork.metro,
  hits.type,
  hits.social.socialInteractionNetwork,
  hits.social.socialInteractionAction,
  hits.hitNumber,
  hits.time/1000 AS hits_time,   /* Converted to seconds */
  hits.hour,
  hits.minute,
  hits.isSecure,
  hits.isInteraction,
  hits.referer,
  hits.page.pagePath,
  hits.page.hostname,
  hits.page.pageTitle,
  hits.page.searchKeyword,
  hits.page.searchCategory,
  
   -- Ecommerce
  hits.transaction.transactionId AS hit_transactionId,
  hits.transaction.transactionRevenue,
  hits.transaction.transactionTax,
  hits.transaction.transactionShipping,
  hits.transaction.affiliation,
  hits.transaction.currencyCode AS hit_transaction_currencyCode,
  hits.transaction.localTransactionRevenue,
  hits.transaction.localTransactionTax,
  hits.transaction.localTransactionShipping,
  hits.transaction.transactionCoupon,
  hits.item.transactionId,
  hits.item.productName,
  hits.item.productCategory,
  hits.item.productSku,
  hits.item.itemQuantity,
  hits.item.itemRevenue,
  hits.item.currencyCode,
  hits.item.localItemRevenue,  

  
  -- Enhanced Ecommerce
  hits.eCommerceAction.action_type, 
  hits.eCommerceAction.step,
  hits.eCommerceAction.option,

  (SELECT productSKU FROM UNNEST(hits.product)) AS hits_product_v2ProductSKU,
  (SELECT v2ProductName FROM UNNEST(hits.product)) AS hits_product_v2ProductName,
  (SELECT v2ProductCategory FROM UNNEST(hits.product)) AS hits_product_v2ProductCategory,
  (SELECT productVariant FROM UNNEST(hits.product)) AS hits_product_productVariant,
  (SELECT productBrand FROM UNNEST(hits.product)) AS hits_product_productBrand,
  (SELECT productRevenue FROM UNNEST(hits.product)) AS hits_product_productRevenue,
  (SELECT localProductRevenue FROM UNNEST(hits.product)) AS hits_product_localProductRevenue,
  (SELECT productPrice FROM UNNEST(hits.product)) AS hits_product_productPrice,
  (SELECT localProductPrice FROM UNNEST(hits.product)) AS hits_product_localProductPrice,
  (SELECT productQuantity FROM UNNEST(hits.product)) AS hits_product_productQuantity,
  (SELECT productRefundAmount FROM UNNEST(hits.product)) AS hits_product_productRefundAmount,
  (SELECT isImpression FROM UNNEST(hits.product)) AS isImpression,

  hits.refund.refundAmount,
  hits.refund.localRefundAmount,

  -- Promotion
  (SELECT promoId FROM UNNEST(hits.promotion)) AS hits_promotion_promoId,
  (SELECT promoName FROM UNNEST(hits.promotion)) AS hits_promotion_promoName,
  (SELECT promoCreative FROM UNNEST(hits.promotion)) AS hits_promotion_promoCreative,
  (SELECT promoPosition FROM UNNEST(hits.promotion)) AS hits_promotion_promoPosition,

  -- Mobile App
  hits.contentInfo.contentDescription,
  hits.appInfo.name,
  hits.appInfo.version,
  hits.appInfo.id,
  hits.appInfo.installerId,
  hits.appInfo.appInstallerId,
  hits.appInfo.appName,
  hits.appInfo.appVersion,
  hits.appInfo.appId,
  hits.appInfo.screenName,
  hits.appInfo.landingScreenName,
  hits.appInfo.exitScreenName,
  hits.appInfo.screenDepth,
  hits.exceptionInfo.description,
  hits.exceptionInfo.isFatal,

  -- Events
  hits.eventInfo.eventCategory,
  hits.eventInfo.eventAction,
  hits.eventInfo.eventLabel,
  hits.eventInfo.eventValue,

  -- Custom Dimensions (Add your custom dimensions by adding a line for each dimension and chaging the index)
  (SELECT MAX(IF(index=1, value, NULL)) FROM UNNEST(hits.customDimensions)) AS dimension1,
  
  -- Custom Metrics (Add your custom metrics by adding a line for each metric)
  (SELECT MAX(IF(index=1, value, NULL)) FROM UNNEST(hits.customMetrics)) AS metric1

  FROM  `dataset_id.ga_sessions_YYYYMMDD` , UNNEST(hits) as hits
