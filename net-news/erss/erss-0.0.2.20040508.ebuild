# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/erss/erss-0.0.2.20040508.ebuild,v 1.2 2004/05/22 00:32:48 vapier Exp $

inherit enlightenment

DESCRIPTION="simple tool for watching RSS v1 (RDF) and v2 (XML) feeds"
HOMEPAGE="http://enlightenment.org/pages/erss.html"

DEPEND=">=media-libs/edje-0.5.0.20040501
	>=x11-libs/esmart-0.0.2.20040501
	>=media-libs/etox-0.0.2.20040327
	>=x11-libs/ecore-1.0.0.20040501_pre7"

EDOCS="data/erssrc"

src_unpack() {
	enlightenment_src_unpack
	sed -i 's:/local/:/:g' ${S}/data/erssrc
}
