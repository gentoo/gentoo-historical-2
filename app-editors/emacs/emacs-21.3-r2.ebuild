# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-21.3-r2.ebuild,v 1.2 2003/12/14 03:55:22 brad_mssw Exp $

IUSE="X nls motif leim gnome Xaw3d"

inherit flag-o-matic

S=${WORKDIR}/${P}
DESCRIPTION="An incredibly powerful, extensible text editor"
SRC_URI="mirror://gnu/emacs/${P}.tar.gz
	leim? ( mirror://gnu/emacs/leim-${PV}.tar.gz )"
HOMEPAGE="http://www.gnu.org/software/emacs"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha amd64"

DEPEND="sys-libs/ncurses
	sys-libs/gdbm
	X? ( virtual/x11
		>=media-libs/libungif-4.1.0.1b
		>=media-libs/jpeg-6b-r2
		>=media-libs/tiff-3.5.5-r3
		>=media-libs/libpng-1.2.1
		Xaw3d? ( x11-libs/Xaw3d )
		motif? ( >=x11-libs/openmotif-2.1.30 )
	)
	nls? ( sys-devel/gettext )
	gnome? ( gnome-base/gnome-desktop )"

PROVIDE="virtual/emacs virtual/editor"
SANDBOX_DISABLED="1"

DFILE=emacs.desktop

# -fstack-protector gets internal compiler error at xterm.c (bug 33265)
filter-flags -fstack-protector

src_compile() {
	epatch ${FILESDIR}/${P}-amd64.patch
	unset WANT_AUTOCONF_2_5
	export WANT_AUTOCONF_2_1=1
	autoconf

	local myconf
	use nls || myconf="${myconf} --disable-nls"
	if [ "`use X`" ] ; then
		myconf="${myconf}
			--with-x
			--with-xpm
			--with-jpeg
			--with-tiff
			--with-gif
			--with-png"
		if [ "`use motif`" ] ; then
			myconf="${myconf} --with-x-toolkit=motif"
		elif [ "`use Xaw3d`" ] ; then
			myconf="${myconf} --with-x-toolkit=athena"
		else
			# do not build emacs with any toolkit, bug 35300
			myconf="${myconf} --with-x-toolkit=no"
		fi
	else
		myconf="${myconf} --without-x"
	fi
	econf ${myconf} || die
	emake || die
}

src_install () {
	einstall || die
	einfo "Fixing info documentation..."
	rm -f ${D}/usr/share/info/dir
	for i in ${D}/usr/share/info/*
	do
		mv ${i%.info} $i.info
	done

	einfo "Fixing permissions..."
	find ${D} -perm 664 |xargs chmod 644
	find ${D} -type d |xargs chmod 755

	dodoc BUGS ChangeLog README

	keepdir /usr/share/emacs/${PV}/leim

	if [ "`use gnome`" ] ; then
		insinto /usr/share/gnome/apps/Application
		doins ${FILESDIR}/${DFILE}
	fi
}
