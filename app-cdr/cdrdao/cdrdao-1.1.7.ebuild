# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.1.7.ebuild,v 1.14 2003/11/20 16:10:34 mholzer Exp $

inherit flag-o-matic

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdrdao/${P}.src.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha"
IUSE="gnome perl"

RDEPEND="gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1
	>=dev-cpp/gnomemm-1.2.2 )
	x86? ( perl? ( dev-perl/libvorbis-perl ) )"
DEPEND=">=dev-util/pccts-1.33.24-r1
	${RDEPEND}"

src_compile() {
	local mygnome=""

	if [ "`use gnome`" ] ; then
		mygnome=" --with-gnome"
		append-flags `/usr/bin/gtkmm-config --cflags` -fno-exceptions
	fi
	# -funroll-loops do not work
	filter-flags "-funroll-loops"

	./configure "${mygnome}" \
		--prefix=/usr \
		--build="${CHOST}"\
		--host="${CHOST}" \
		|| die "configure failed"
	emake || die
}

src_install() {
	# cdrdao gets definitely installed
	# binary
	dobin dao/cdrdao

	# data of cdrdao in /usr/share/cdrdao/
	# (right now only driverlist)
	insinto /usr/share/cdrdao
	newins dao/cdrdao.drivers drivers

	# man page
	into /usr
	newman dao/cdrdao.man cdrdao.1

	# documentation
	docinto ""
	dodoc COPYING CREDITS INSTALL README* Release*

	# and now the optional GNOME frontend
	if [ "`use gnome`" ] ; then
		# binary
		into /usr
		dobin xdao/gcdmaster

		# pixmaps for gcdmaster in /usr/share/pixmaps/gcdmaster
		insinto /usr/share/pixmaps/gcdmaster
		doins xdao/*.png xdao/*.xpm

		# application links
		# gcdmaster.desktop in /usr/share/gnome/apps/Applications
		insinto /usr/share/gnome/apps/Applications
		doins xdao/gcdmaster.desktop

		# xcdrdao.1 renamed to gcdmaster.1 in /usr/share/man/man1/
		into /usr
		newman xdao/xcdrdao.man gcdmaster.1
	fi
}
