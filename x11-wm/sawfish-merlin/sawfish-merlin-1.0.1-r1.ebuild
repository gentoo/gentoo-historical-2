# Copyright 2001 theLeaf sprl/bvba
# Author Geert Bevin <gbevin@theleaf.be>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/sawfish-merlin/sawfish-merlin-1.0.1-r1.ebuild,v 1.2 2002/04/28 04:15:49 seemant Exp $

MY_P=${P/-merlin/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Extensions for sawfish which provide pages, iconbox and other nice things."
SRC_URI="http://prdownloads.sourceforge.net/sawmill/${MY_P}.tar.gz"
HOMEPAGE="http://www.merlin.org/sawfish"

DEPEND=">=dev-libs/rep-gtk-0.15-r1
	>=dev-libs/librep-0.14
	>=media-libs/imlib-1.9.10-r1
	esd? ( >=media-sound/esound-0.2.22 )
	gtk? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )
	gnome? ( >=gnome-base/gnome-core-1.4.0.4-r1
		>=media-libs/gdk-pixbuf-0.11.0-r1 )"

RDEPEND="${DEPEND}
	>=x11-libs/gtk+-1.2.10-r4
	nls? ( sys-devel/gettext )"

src_unpack() {

	unpack ${A}

	cd ${S}
	patch -p0 <${FILESDIR}/capplet-crash.patch || die
	#fix buggy Makefile with newer libtool
	patch -p0 <${FILESDIR}/sawfish-${PV}-exec.patch || die

	cd ${S}/po
	cd ${S}/src
	patch -p1 < ${FILESDIR}/x.c.patch-merlin-1.0.2 || die

	#update libtool for "relink" bug fix
	libtoolize --copy --force
	aclocal
}


src_compile() {

  	local myconf
	
	use esd	\
		&& myconf="--with-esd"	\
		|| myconf="--without-esd"
	
	use gnome	\
		&& myconf="${myconf} --with-gnome-prefix=/usr --enable-gnome-widgets --enable-capplet"	\
		|| myconf="${myconf} --disable-gnome-widgets --disable-capplet"
	
	use nls || myconf="${myconf} --disable-linguas"

	use gtk || use gnome 	\
		&& myconf="${myconf} --with-gdk-pixbuf"	\
		|| myconf="${myconf} --without-gdk-pixbuf"

	./configure	\
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--libexecdir=/usr/lib \
		--with-audiofile \
		${myconf} || die

	emake || die
}

src_install() {
	mkdir -p ${D}/usr/lib/sawfish/${PV}/sawfish-merlin/sawfish/wm/util
	cp src/.libs/x.* ${D}/usr/lib/sawfish/${PV}/sawfish-merlin
	cp src/.libs/x.* ${D}/usr/lib/sawfish/${PV}/sawfish-merlin/sawfish/wm/util
	
	dodir /etc/X11/gdm/Sessions/
	exeinto /etc/X11/gdm/Sessions/
	newexe ${FILESDIR}/gdm_session Sawfish
	
	dodir /etc/skel
	insinto /etc/skel
	cp -a ${FILESDIR}/sawfish ${D}/etc/skel/.sawfish
	find ${D}/etc/skel/.sawfish -name "CVS" -exec rm -rf '{}' ';'
	cp -a ${FILESDIR}/sawfishrc ${D}/etc/skel/.sawfishrc
}
