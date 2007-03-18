# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kexi/kexi-1.6.2-r1.ebuild,v 1.1 2007/03/18 22:35:00 carlo Exp $

MAXKOFFICEVER=${PV}
KMNAME=koffice
inherit kde-meta eutils

DESCRIPTION="KOffice integrated environment for database management."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="mysql postgres kdeenablefinal"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	sys-libs/readline
	mysql? ( virtual/mysql )
	postgres? ( <dev-libs/libpqxx-2.6.9 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkoproperty lib/koproperty
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkrossmain lib/kross/main/
	libkrossapi lib/kross/api/"

KMEXTRACTONLY="lib/"

need-kde 3.4

PATCHES="${FILESDIR}/kexi-1.6.2-build_kexi_file.diff"

src_compile() {
	local myconf="$(use_enable mysql) $(use_enable postgres pgsql) --enable-kexi-reports"

	# Labplot needs the header file
	sed -i -e "s:utils.h:utils.h parser/parser.h:" kexi/kexidb/Makefile.am || die "sed failed"
	kde-meta_src_compile
}
