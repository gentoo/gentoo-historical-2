# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gnucap/gnucap-0.35.20071121.ebuild,v 1.1 2007/11/28 22:47:41 calchan Exp $

inherit multilib

SNAPSHOTDATE="${P##*.}"
MY_PV="${PN}-${SNAPSHOTDATE:0:4}-${SNAPSHOTDATE:4:2}-${SNAPSHOTDATE:6:2}"

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="http://www.gnucap.org/devel/${MY_PV}.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-bsim.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-ngspice17.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-spice3f5.tar.gz"
HOMEPAGE="http://www.gnucap.org/"

IUSE="doc examples"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="doc? ( virtual/tetex )"

S="${WORKDIR}/${MY_PV}"

src_unpack() {
	unpack ${A} || die "Failed to unpack!"
	cd "${S}"

	# No need to install COPYING and INSTALL
	sed -i \
		-e 's: COPYING INSTALL::' \
		-e 's:COPYING history INSTALL:history:' \
		doc/Makefile.in || die "sed failed"

	if ! use doc ; then
		sed -i \
			-e 's:SUBDIRS = doc examples man:SUBDIRS = doc examples:' \
			Makefile.in || die "sed failed"
	fi

	if ! use examples ; then
		sed -i \
			-e 's:SUBDIRS = doc examples:SUBDIRS = doc:' \
			Makefile.in || die "sed failed"
	fi

	# Move all plugins in the same directory so that it's easier to iterate through them
	# without having to change the code every time they change
	mkdir plugins
	for PLUGIN_DIR in ../* ; do
		if [[ ${PLUGIN_DIR} != "../${MY_PV}" ]] ; then mv ${PLUGIN_DIR} plugins ; fi
	done

	sed -i -e "s:CFLAGS = -O2 -g:CFLAGS +=:" \
		-e "s:CCFLAGS = \$(CFLAGS):CCFLAGS += \$(CFLAGS):" \
		-e "s:../Gnucap:${S}/src:" \
		plugins/*/Make2 || die "sed failed"
}

src_compile () {
	econf --disable-dependency-tracking || die "Configuration failed"
	emake || die "Compilation failed"
	for PLUGIN_DIR in plugins/* ; do
		cd "${S}/${PLUGIN_DIR}"
		emake || die "Compilation failed in ${PLUGIN_DIR}"
	done
}

src_install () {
	emake DESTDIR="${D}" install || die "Installation failed"
	insopts -m0755
	for PLUGIN_DIR in plugins/* ; do
		insinto /usr/$(get_libdir)/gnucap/${PLUGIN_DIR}
		cd "${S}/${PLUGIN_DIR}"
		for PLUGIN in */*.so ; do
			newins ${PLUGIN} ${PLUGIN##*/} \
			|| die "Installation of ${PLUGIN_DIR}/${PLUGIN} failed"
		done
	done
}
