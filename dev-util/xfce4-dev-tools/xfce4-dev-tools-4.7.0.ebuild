# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xfce4-dev-tools/xfce4-dev-tools-4.7.0.ebuild,v 1.3 2009/10/03 21:57:49 tcunha Exp $

EAPI="2"
inherit xfconf

DESCRIPTION="set of scripts and m4/autoconf macros that ease build system maintenance for XFCE"
HOMEPAGE="http://foo-projects.org/~benny/projects/xfce4-dev-tools"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/4.7/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DOCS="AUTHORS ChangeLog HACKING NEWS README"
