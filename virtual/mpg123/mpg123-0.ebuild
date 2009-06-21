# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mpg123/mpg123-0.ebuild,v 1.5 2009/06/21 07:44:13 ssuominen Exp $

EAPI=2

DESCRIPTION="Virtual for command-line players mpg123 and mpg321"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| ( >=media-sound/mpg123-1.7.3-r1
	>=media-sound/mpg321-0.2.10-r4[symlink] )"
DEPEND="${RDEPEND}"
