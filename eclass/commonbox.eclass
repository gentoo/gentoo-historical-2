# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# Author: Seemant Kulleen <seemant@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/commonbox.eclass,v 1.8 2002/09/04 12:18:42 seemant Exp $

# The commonbox eclass is designed to allow easier installation of the box
# window managers such as blackbox and fluxbox and commonbox
# The common utilities of those window managers get installed in the
# commonbox-utils dependency, and default styles with the commonbox-styles
# utility.  They all share the /usr/share/commonbox directory now.

ECLASS=commonbox
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst

DEPEND="x11-misc/commonbox-utils
	x11-themes/commonbox-styles"

RDEPEND="nls? ( sys-devel/gettext )"
PROVIDE="virtual/blackbox"

myconf=""
mydoc=""
BOOTSTRAP=""

if [ -z "${MYBIN}" ]
then
	MYBIN="${PN}"
fi

commonbox_src_unpack() {

	unpack ${A}

	cd ${S}
	cp Makefile.am Makefile.am.orig
	sed 's/data //' Makefile.am.orig > Makefile.am

	cd ${S}/util
	cp Makefile.am Makefile.am.orig
	sed -e 's/bsetbg//' \
		-e 's/bsetroot//' \
		Makefile.am.orig > Makefile.am


	cd ${S}/doc
	cp Makefile.am Makefile.am.orig
	sed -e "s:bsetroot.1::" \
		-e "s:bsetbg.1::" \
		Makefile.am.orig > Makefile.am

	einfo ${MYBIN}

}

commonbox_src_compile() {

	if [ -z "${BOOTSTRAP}" ]
	then
		aclocal
		automake
		autoconf
	fi

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
		--sysconfdir=/etc/X11/${MYBIN} \
		--datadir=/usr/share/commonbox \
		${myconf} || die
	
	emake \
		pkgdatadir=/usr/share/commonbox/${MYBIN} || die
		
}


commonbox_src_install() {

	dodir /usr/share/commonbox
	einstall \
		pkgdatadir=${D}/usr/share/commonbox/${MYBIN} || die

	# move the ${PN} binary to ${MYBIN}

	if [ "${MYBIN}" != "${PN}" ]
	then
		mv ${D}/usr/bin/${PN} ${D}/usr/bin/${MYBIN}
	
		# same to manpage
		rm ${D}/usr/share/man/man1/${PN}.1
		mv doc/${PN}.1 doc/${MYBIN}.1
		doman doc/${MYBIN}.1
	fi

	dodoc README* AUTHORS TODO* ${mydoc}

	# move nls stuff
	use nls && ( \
		dodir /usr/share/commonbox/${MYBIN}
		mv ${D}/usr/share/${PN}/nls ${D}/usr/share/commonbox/${MYBIN}
	)
	
	rmdir ${D}/usr/share/${MYBIN}
	
	dodir /etc/X11/Sessions
	echo "/usr/bin/${MYBIN}" > ${D}/etc/X11/Sessions/${MYBIN}
	fperms a+x /etc/X11/Sessions/${MYBIN}
}

commonbox_pkg_postinst() {
	#notify user about the new share dir
	if [ -d /usr/share/commonbox ]
	then
		einfo
		einfo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		einfo "! ${MYBIN} no longer uses /usr/share/${MYBIN} as the  !"
		einfo "! default share directory to contain styles and menus.      !"
		einfo "! The default directory is now /usr/share/commonbox         !"
		einfo "! Please move any files in /usr/share/${MYBIN} that you  !"
		einfo "! wish to keep (personal styles and your menu) into the     !"
		einfo "! new directory and modify your menu files to point all     !"
		einfo "! listed paths to the new directory.			       !"
		einfo "! Also, be sure to update the paths in each user's	       !"
		einfo "! config file found in their home directory.	               !"
		einfo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		einfo
	fi
}
