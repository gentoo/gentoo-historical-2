# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khelpcenter/khelpcenter-4.0.4.ebuild,v 1.1 2008/05/15 23:41:17 ingmar Exp $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="The KDE Help Center"
IUSE="debug htmlhandbook"
KEYWORDS="~amd64 ~x86"

KMEXTRA="doc/faq
	doc/glossary
	doc/quickstart
	doc/userguide
	doc/visualdict"

DEPEND=""
RDEPEND=">=www-misc/htdig-3.2.0_beta6-r1"
