# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# Author: Seemant Kulleen <seemant@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/commonbox.eclass,v 1.2 2002/07/14 23:01:40 seemant Exp $

# The commonbox eclass is designed to allow easier installation of the box
# window managers such as blackbox and fluxbox and commonbox
# The common utilities of those window managers get installed in the
# commonbox-utils dependency, and default styles with the commonbox-styles
# utility.  They all share the /usr/share/commonbox directory now.

ECLASS=commonbox
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS commonify src_compile src_install

DEPEND="x11-misc/commonbox-utils
	x11-misc/commonbox-styles"

RDEPEND="nls? ( sys-devel/gettext )"
PROVIDE="virtual/blackbox"

myconf=""
mydoc=""
MYBIN=""

commonbox_commonify() {
	cd ${S}

	cp Makefile Makefile.orig
	sed -e "s:\(SUBDIRS = \).*:\1doc nls src:" \
		Makefile.orig > Makefile

	cd ${S}/doc

	cp Makefile Makefile.orig
	sed -e "s:bsetroot.1::" \
		-e "s:bsetbg.1::" \
		Makefile.orig > Makefile

	cd ${S}/src
	cp Makefile Makefile.orig
	sed -e "s:\(DEFAULT_MENU = \).*:\1/usr/share/commonbox/menu:" \
		-e "s:\(DEFAULT_STYLE = \).*:\1/usr/share/commonbox/styles/Clean:" \
		-e "s:\(DEFAULT_INITFILE = \).*:\1/usr/share/commonbox/init:" \
		Makefile.orig > Makefile

	cd ${S}

}

commonbox_src_compile() {

	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	use kde \
		&& myconf="${myconf} --enable-kde" \
		|| myconf="${myconf} --disable-kde"

	use gnome \
		&& myconf="${myconf} --enable-gnome" \
		|| myconf="${myconf} --disable-gnome"

	econf \
		--sysconfdir=/etc/X11/${PN} \
		--datadir=/usr/share/commonbox \
		${myconf} || die
	
	commonify || die
	emake || die
}


commonbox_src_install() {

	dodir /usr/share/commonbox
	einstall || die

	dodoc README* AUTHORS TODO* ${mydoc}

	if [ -z "${MYBIN}" ]
	then
		MYBIN=${PN}
	fi

	# move nls stuff
	use nls && ( \
		dodir /usr/share/commonbox/${MYBIN}
		mv ${D}/usr/share/${MYBIN}/nls ${D}/usr/share/commonbox/${MYBIN}
	)
	
	rmdir ${D}/usr/share/${MYBIN}
	
	dodir /etc/X11/Sessions
	echo "/usr/bin/${MYBIN}" > ${D}/etc/X11/Sessions/${MYBIN}
	fperms 755 /etc/X11/Sessions/${MYBIN}
}
