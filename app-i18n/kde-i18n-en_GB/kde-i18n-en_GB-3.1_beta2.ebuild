# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kde-i18n-en_GB/kde-i18n-en_GB-3.1_beta2.ebuild,v 1.1 2002/10/17 23:33:36 hannes Exp $

inherit kde-i18n

# override the kde-i18n.eclass function, which adds a patch needed
# for all kde-i18n ebuilds but this
src_unpack() {
	unpack ${A//kde-i18n-gentoo.patch}
}
