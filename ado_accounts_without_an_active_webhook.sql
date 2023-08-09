SELECT
	'ADO' as integration_type,
    a.name AS account_name,
    p.name AS workspace_name,
    p.id AS workspace_id,
    pack.name AS package_name,
    u.login AS owner_email,
    u.is_payer,
    u.trial_begin,
    u.trial_end,
	now()-u.trial_end as days_since_trial_ended,
	u.package as package_code
FROM
    ct_craft_tfs_projects ap
LEFT JOIN
    ct_craft_products p ON p.id = ap.ct_craft_product_id
LEFT JOIN
    ct_account a ON a.id = p.account_id
LEFT JOIN
    ct_users u ON a.owner_id = u.id
LEFT JOIN
	craft_packages pack ON u.package = pack.id
WHERE
    NOT COALESCE(ap.tfs_webhook_connected, false)
    AND NOT COALESCE(ap.is_archive, false)
    AND ap.ct_craft_product_id IS NOT NULL
    AND u.login NOT ILIKE '%craft.io'
    AND u.login NOT ILIKE '%synergetica%'
    AND u.login NOT ILIKE '%yopmail.com'
    AND NOT COALESCE(p.is_archival, false);
