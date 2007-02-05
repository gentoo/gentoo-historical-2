# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xemacs/xemacs-21.4.20-r1.ebuild,v 1.7 2007/02/05 19:22:42 wolf31o2 Exp $

export WANT_AUTOCONF="2.1"
inherit autotools eutils

DESCRIPTION="highly customizable open source text editor and application development system"
HOMEPAGE="http://www.xemacs.org/"
SRC_URI="http://ftp.xemacs.org/xemacs-21.4/${P}.tar.gz
	http://www.malfunction.de/afterstep/files/NeXT_XEmacs.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ppc ppc64 sparc x86"
IUSE="eolconv esd gif gpm pop postgres ldap xface nas dnd X jpeg tiff png mule motif freewnn canna athena neXt Xaw3d gdbm berkdb"

X_DEPEND="x11-libs/libXt x11-libs/libXmu x11-libs/libXext x11-misc/xbitmaps"

DEPEND="virtual/libc
	!virtual/xemacs
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.3 )
	>=sys-libs/zlib-1.1.4
	>=dev-libs/openssl-0.9.6
	>=media-libs/audiofile-0.2.3
	gpm? ( >=sys-libs/gpm-1.19.6 )
	postgres? ( >=dev-db/postgresql-7.2 )
	ldap? ( net-nds/openldap )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	X? ( $X_DEPEND !Xaw3d? ( !neXt? ( x11-libs/libXaw ) ) )
	dnd? ( x11-libs/dnd )
	motif? ( >=x11-libs/openmotif-2.1.30 )
	athena? ( x11-libs/libXaw )
	Xaw3d? ( x11-libs/Xaw3d )
	neXt? ( x11-libs/neXtaw )
	xface? ( media-libs/compface )
	tiff? ( media-libs/tiff )
	png? ( =media-libs/libpng-1.2* )
	jpeg? ( media-libs/jpeg )
	canna? ( app-i18n/canna )
	!amd64? ( freewnn? ( app-i18n/freewnn ) )
	>=sys-libs/ncurses-5.2"

PDEPEND="app-xemacs/xemacs-base
	mule? ( app-xemacs/mule-base )"

PROVIDE="virtual/xemacs virtual/editor"

src_unpack() {
	unpack ${P}.tar.gz
	use neXt && unpack NeXT_XEmacs.tar.gz

	cd "${S}"
	epatch ${FILESDIR}/xemacs-21.4.19-texi.patch

	# see bug 58350, 102540 and 143580
	epatch "${FILESDIR}"/xemacs-21.4.19-db.patch

	# Fix constent crashes with the combination native sound,linux,wav
	epatch "${FILESDIR}"/xemacs-21.4.20-linuxplay.patch

	# Run autoconf. XEmacs tries to be smart by providing a stub
	# configure.ac file for autoconf 2.59 but this throws our
	# autotools eclass so it must be removed first.
	rm "${S}"/configure.ac
	eautoconf

	use neXt && cp "${WORKDIR}"/NeXT.XEmacs/xemacs-icons/* "${S}"/etc/toolbar/
}

src_compile() {
	local myconf=""

	if use X; then

		myconf="${myconf} --with-widgets=athena"
		myconf="${myconf} --with-dialogs=athena"
		myconf="${myconf} --with-menubars=lucid"
		myconf="${myconf} --with-scrollbars=lucid"
		if use motif ; then
			myconf="--with-widgets=motif"
			myconf="${myconf} --with-dialogs=motif"
			myconf="${myconf} --with-scrollbars=motif"
			myconf="${myconf} --with-menubars=lucid"
		fi
		if use athena ; then
			myconf="--with-scrollbars=athena"
		fi

		if use Xaw3d; then
			myconf="${myconf} --with-athena=3d"
		elif use neXt; then
			myconf="${myconf} --with-athena=next"
		else
			myconf="${myconf} --with-athena=xaw"
		fi

		use dnd && myconf="${myconf} --with-dragndrop --with-offix"

		use tiff && myconf="${myconf} --with-tiff" ||
			myconf="${myconf} --without-tiff"
		use png && myconf="${myconf} --with-png" ||
			myconf="${myconf} --without-png"
		use jpeg && myconf="${myconf} --with-jpeg" ||
			myconf="${myconf} --without-jpeg"
		use xface && myconf="${myconf} --with-xface" ||
			myconf="${myconf} --without-xface"

	else
		myconf="${myconf}
			--without-x
			--without-xpm
			--without-dragndrop
			--with-gif=no"
	fi

	if use mule ; then
		myconf="${myconf} --with-mule"
		use motif && myconf="${myconf} --with-xim=motif" ||
			myconf="${myconf} --with-xim=xlib"
			use canna && myconf="${myconf} --with-canna" ||
					myconf="${myconf} --without-canna"
		use freewnn && myconf="${myconf} --with-wnn" ||
					myconf="${myconf} --without-wnn"
	fi

	# This determines the type of sounds we are playing
	local soundconf="native"

	# This determines how these sounds should be played
	use nas	&& soundconf="${soundconf},nas"
	use esd && soundconf="${soundcond},esd"

	myconf="${myconf} --with-sound=${soundconf}"

	if use gdbm || use berkdb ; then
		use gdbm && mydb="gdbm"

		use berkdb && mydb="${mydb},berkdb"

		myconf="${myconf} --with-database=${mydb}"
	else
		myconf="${myconf} --without-database"
	fi

	# fixes #21264
	use alpha && myconf="${myconf} --with-system-malloc"

	use ppc64 && myconf="${myconf} --with-system-malloc"

	# Don't use econf because it uses options which this configure
	# script does not understand (like --host).
	./configure ${myconf} ${EXTRA_ECONF} \
		$(use_with gif ) \
		$(use_with gpm ) \
		$(use_with postgres postgresql ) \
		$(use_with ldap ) \
		$(use_with eolconv file-coding ) \
		$(use_with pop ) \
		--prefix=/usr \
		--with-ncurses \
		--with-msw=no \
		--mail-locking=flock \
		--with-site-lisp=yes \
		--with-site-modules=yes \
		|| die

	emake || die
}

src_install() {
	make prefix="${D}"/usr \
		mandir="${D}"/usr/share/man/man1 \
		infodir="${D}"/usr/share/info \
		install gzip-el || die

	# Rename some applications installed in bin so that it is clear
	# which application installed them and so that conflicting
	# packages (emacs) can't clobber the actual applications.
	# Addresses bug #62991.
	for i in b2m ctags etags rcs-checkin ; do
		mv "${D}"/usr/bin/${i} "${D}"/usr/bin/${i}-xemacs || die "mv ${i} failed"
		dosym /usr/bin/${i}-xemacs /usr/bin/${i}
	done

	# install base packages directories
	dodir /usr/lib/xemacs/xemacs-packages/
	dodir /usr/lib/xemacs/site-packages/
	dodir /usr/lib/xemacs/site-modules/
	dodir /usr/lib/xemacs/site-lisp/

	if use mule;
	then
		dodir /usr/lib/xemacs/mule-packages
	fi

	# remove extraneous info files
	cd "${D}"/usr/share/info
	rm -f dir info.info texinfo* termcap* standards*

	cd "${S}"
	dodoc BUGS CHANGES-* ChangeLog GETTING* INSTALL PROBLEMS README*
	dodoc "${FILESDIR}"/README.Gentoo

	insinto /usr/share/pixmaps
	newins "${S}"/etc/${PN}-icon.xpm ${PN}.xpm

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
}

