# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xemacs-gamma/xemacs-gamma-21.4.6.ebuild,v 1.11 2002/10/20 18:37:25 vapier Exp $

IUSE="gpm motif postgres xface tiff gtk jpeg mule nas esd X png gnome"

# this is just TEMPORARY until we can get to the core of the problem
SANDBOX_DISABLED="1"

REAL_P=${P//-gamma/}
S="${WORKDIR}/${REAL_P}"
DESCRIPTION="XEmacs is a highly customizable open source text editor and application development system."
EFS=1.28
BASE=1.61
MULE=1.39
SRC_URI="http://ftp.us.xemacs.org/ftp/pub/xemacs/xemacs-21.4/${REAL_P}.tar.gz
	http://ftp.us.xemacs.org/ftp/pub/xemacs/packages/efs-${EFS}-pkg.tar.gz
	http://ftp.us.xemacs.org/ftp/pub/xemacs/packages/xemacs-base-${BASE}-pkg.tar.gz
	http://ibiblio.org/pub/packages/editors/xemacs/packages/mule-base-${MULE}-pkg.tar.gz"
HOMEPAGE="http://www.xemacs.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND=">=sys-libs/gdbm-1.8.0
	>=sys-libs/zlib-1.1.4
	>=dev-libs/openssl-0.9.6
	>=media-libs/audiofile-0.2.3

	xface? ( media-libs/compface )
	gpm? ( >=sys-libs/gpm-1.20.0 )
	postgres? ( >=dev-db/postgresql-7.2 )

	nas? ( media-libs/nas )
	esd? ( media-sound/esound )

	motif? ( >=x11-libs/openmotif-2.1.30 )
	gtk? ( =x11/libs/gtk+-1.2* )
	gnome? ( =gnome-base/gnome-core-1.4* )

	tiff? ( media-libs/tiff )
	png? ( =media-libs/libpng-1.2* )
	jpeg? ( media-libs/jpeg )

	X? ( virtual/x11 )"

src_unpack() {
	cd ${WORKDIR}
	unpack ${REAL_P}.tar.gz
	patch -p0 <${FILESDIR}/emodules.info-gentoo.patch
}

src_compile() {
	local myconf=""

	if use X;
	then
		myconf="${myconf} 
			--with-x 
			--with-xpm 
			--without-dragndrop 
			--with-gif=no"

		use tiff && myconf="${myconf} --with-tiff" || 
			myconf="${myconf} --without-tiff"
		use png && mconf="${myconf} --with-png" || 
			myconf="${myconf} --without-png"
		use jpeg && myconf="${myconf} --with-jpeg" ||
			myconf="${myconf} --without-jpeg"
		use xface && myconf="${myconf} --with-xface" ||
			myconf="${myconf} --without-xface"

		local USE_PREF=lucid

		case $USE_PREF in
			gtk )
				myconf="${myconf} --with-gtk"
				use gnome && myconf="${myconf} --with-gnome" ||
					myconf="${myconf} --without-gnome"
			;;
			lucid )
				myconf="${myconf} --with-dialogs=lucid --with-widgets=lucid"
				myconf="${myconf} --with-scrollbars=lucid"
				myconf="${myconf} --with-menubars=lucid"
			;;
			motif )
				myconf="${myconf} --with-dialogs=motif --with-widgets=motif"
#				myconf="${myconf} --with-scrollbars=motif"
#				myconf="${myconf} --with-menubars=motif"
				myconf="${myconf} --with-scrollbars=lucid"
				myconf="${myconf} --with-menubars=lucid"
			;;
			* )
				einfo "Sorry, $USE_PREF is not a supported USE_PREF"
				die
			;;
		esac
	else
		myconf="${myconf} 
			--without-x 
			--without-xpm 
			--without-dragndrop 
			--with-gif=no"
	fi

	use gpm	&& myconf="${myconf} --with-gpm" ||
		myconf="${myconf} --without-gpm"
	use postgres && myconf="${myconf} --with-postgresql" ||
		myconf="${myconf} --without-postgresql"
	use mule && myconf="${myconf} --with-mule" ||
		myconf="${myconf} --without-mule"
	
	local soundconf="native"

	use nas	&& soundconf="${soundconf},nas"
	use esd	&& soundconf="${soundconf},esd"

	myconf="${myconf} --with-sound=${soundconf}"

	./configure ${myconf} \
		--prefix=/usr \
		--with-database=gnudbm \
		--with-pop \
		--with-ncurses \
		--with-site-lisp=yes \
		--package-path=/usr/lib/xemacs/xemacs-packages/ \
		--with-msw=no \
		|| die

	emake || die
}

src_install() {                               
	make prefix="${D}/usr" \
		mandir="${D}/usr/share/man/man1" \
		infodir="${D}/usr/share/info" \
		install gzip-el || die
	
	# install base packages
	dodir /usr/lib/xemacs/xemacs-packages/
	cd ${D}/usr/lib/xemacs/xemacs-packages/
	unpack efs-${EFS}-pkg.tar.gz
	unpack xemacs-base-${BASE}-pkg.tar.gz
	# (optionally) install mule base package 
	if use mule;
	then
		dodir /usr/lib/xemacs/mule-packages
		cd ${D}/usr/lib/xemacs/mule-packages/
		unpack mule-base-${MULE}-pkg.tar.gz
	fi
	
	# remove extraneous files
	cd ${D}/usr/share/info
	rm -f dir info.info texinfo* termcap*
	cd ${S}
	dodoc BUGS CHANGES-* COPYING ChangeLog GETTING* INSTALL PROBLEMS README*
}
