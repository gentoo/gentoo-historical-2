# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.1.5-r1.ebuild,v 1.28 2004/02/22 06:17:59 mr_bones_ Exp $

inherit flag-o-matic eutils
strip-flags -funroll-loops

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdrdao/${P}.src.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "
IUSE="gnome perl oggvorbis"

RDEPEND="gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1
	<dev-cpp/gtkmm-1.3.0
	>=dev-cpp/gnomemm-1.1.17 )
	x86? ( perl? ( oggvorbis? ( dev-perl/libvorbis-perl ) ) )"

DEPEND=">=dev-util/pccts-1.33.24-r1
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-c++.patch

	[ ! "`use gnome`" ] && epatch ${FILESDIR}/${P}-gentoo.diff

	cd ${S}/dao
	wget http://cdrdao.sourceforge.net/${P}.drivers
	if [ -f ${P}.drivers ]; then
		rm -f cdrdao.drivers
		mv ${P}.drivers cdrdao.drivers
	fi
}

src_compile() {
	local mygnome=""

	# Gtk version is broken :(
	#	if [ "`use gnome`" ] ; then
	#		mygnome=" --with-gnome"
	#		CFLAGS="${CFLAGS} `/usr/bin/gtkmm-config --cflags`"
	#		CXXFLAGS="${CXXFLAGS} `/usr/bin/gtkmm-config --cflags` -fno-exceptions"
	#
	#	fi

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
	dodoc COPYING CREDITS INSTALL README* Release*

	# and now the optional GNOME frontend
	#	if [ "`use gnome`" ]
	#	then
	#
	#		# binary
	#		into /usr
	#		dobin xdao/gcdmaster
	#
	#		# pixmaps for gcdmaster in /usr/share/pixmaps/gcdmaster
	#		insinto /usr/share/pixmaps/gcdmaster
	#		doins xdao/pixmap_copycd.png
	#		doins xdao/pixmap_audiocd.png
	#		doins xdao/pixmap_datacd.png
	#		doins xdao/pixmap_open.png
	#		doins xdao/pixmap_mixedcd.png
	#		doins xdao/pixmap_cd.png
	#		doins xdao/pixmap_help.png
	#		doins xdao/pixmap_dumpcd.png
	#		doins xdao/gcdmaster.png
	#
	#		# application links
	#		# gcdmaster.desktop in /usr/share/gnome/apps/Applications
	#		insinto /usr/share/gnome/apps/Applications
	#		doins xdao/gcdmaster.desktop
	#
	#		# xcdrdao.1 renamed to gcdmaster.1 in /usr/share/man/man1/
	#		into /usr
	#		newman xdao/xcdrdao.man gcdmaster.1
	#	fi
}
