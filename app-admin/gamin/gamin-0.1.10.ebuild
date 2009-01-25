# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gamin/gamin-0.1.10.ebuild,v 1.5 2009/01/25 15:22:00 klausman Exp $

DESCRIPTION="Meta package providing the File Alteration Monitor API & Server"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="!app-admin/fam
	>=dev-libs/libgamin-0.1.10"
DEPEND=""

PDEPEND=">=app-admin/gam-server-0.1.10"

PROVIDE="virtual/fam"
