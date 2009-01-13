# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-strigi-analyzer/kdesdk-strigi-analyzer-4.1.4.ebuild,v 1.1 2009/01/13 21:51:04 alexxy Exp $

EAPI="2"

KMNAME=kdesdk
KMMODULE=strigi-analyzer
inherit kde4-meta

DESCRIPTION="kdesdk: strigi plugins"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND=">=app-misc/strigi-0.5.9"
RDEPEND="${DEPEND}"
