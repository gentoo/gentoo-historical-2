# Copyright 2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Peter Kadau <peter.kadau@web.de>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.1.5-r1.ebuild,v 1.2 2001/11/10 02:36:20 hallski Exp $

S=${WORKDIR}/cdrdao-1.1.5
DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.src.tar.gz"
HOMEPAGE="http://cdrdao.sourceforge.net/"

DEPEND=">=dev-util/pccts-1.33.24-r1"

if [ "`use gnome`" ]
then 
	RDEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
         >=x11-libs/gtkmm-1.2.5-r1
         >=gnome-extra/gnomemm-1.1.17"
else
	RDEPEND=""
fi

DEPEND="${DEPEND} ${RDEPEND}"

src_unpack() {
	unpack ${A}
	if [ "`use gnome`" ]
	then
		:
	else
		patch -p0 <${FILESDIR}/${PF}-gentoo.diff
	fi
}

src_compile() {
	local mygnome=""
	if [ "`use gnome`" ]
	then
		mygnome=" --with-gnome"
	fi	

	try ./configure "${mygnome}" --prefix=/usr --build="${CHOST}"\
			--host="${CHOST}"
	try emake
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
	# 
	# and now the optional GNOME frontend
	if [ "`use gnome`" ]
	then

		# binary
		into /usr
        	dobin xdao/gcdmaster
		# pixmaps for gcdmaster in /usr/share/pixmaps/gcdmaster
		insinto /usr/share/pixmaps/gcdmaster
		doins xdao/pixmap_copycd.png 
		doins xdao/pixmap_audiocd.png
		doins xdao/pixmap_datacd.png
		doins xdao/pixmap_open.png 
		doins xdao/pixmap_mixedcd.png 
		doins xdao/pixmap_cd.png
		doins xdao/pixmap_help.png 
		doins xdao/pixmap_dumpcd.png
		doins xdao/gcdmaster.png
		# application links
		# gcdmaster.desktop in /usr/share/gnome/apps/Applications
		insinto /usr/share/gnome/apps/Applications
		doins xdao/gcdmaster.desktop
		# xcdrdao.1 renamed to gcdmaster.1 in /usr/share/man/man1/
		into /usr
		newman xdao/xcdrdao.man gcdmaster.1
	fi
}
