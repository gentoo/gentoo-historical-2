# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxml2/libxml2-2.7.3-r2.ebuild,v 1.1 2009/08/11 21:44:34 eva Exp $

inherit libtool flag-o-matic eutils python

DESCRIPTION="Version 2 of the library to manipulate XML files"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="debug doc examples ipv6 python readline test"

XSTS_HOME="http://www.w3.org/XML/2004/xml-schema-test-suite"
XSTS_NAME_1="xmlschema2002-01-16"
XSTS_NAME_2="xmlschema2004-01-14"
XSTS_TARBALL_1="xsts-2002-01-16.tar.gz"
XSTS_TARBALL_2="xsts-2004-01-14.tar.gz"

SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz
	test? (
		${XSTS_HOME}/${XSTS_NAME_1}/${XSTS_TARBALL_1}
		${XSTS_HOME}/${XSTS_NAME_2}/${XSTS_TARBALL_2} )"

RDEPEND="sys-libs/zlib
	python?   ( dev-lang/python )
	readline? ( sys-libs/readline )"

DEPEND="${RDEPEND}
	hppa? ( >=sys-devel/binutils-2.15.92.0.2 )"

src_unpack() {
	# ${A} isn't used to avoid unpacking of test tarballs into $WORKDIR,
	# as they are needed as tarballs in ${S}/xstc instead and not unpacked
	unpack ${P}.tar.gz
	cd "${S}"

	if use test; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
	fi

	# Fix macro conflict with wxGTK, bug #266653
	epatch "${FILESDIR}/${P}-printf-rename.patch"

	# Fix multiple use-after-free, bug #280617
	epatch "${FILESDIR}/${P}-CVE-2009-2414-CVE-2009-2416.patch"

	epunt_cxx
}

src_compile() {
	# USE zlib support breaks gnome2
	# (libgnomeprint for instance fails to compile with
	# fresh install, and existing) - <azarah@gentoo.org> (22 Dec 2002).

	# The meaning of the 'debug' USE flag does not apply to the --with-debug
	# switch (enabling the libxml2 debug module). See bug #100898.

	# --with-mem-debug causes unusual segmentation faults (bug #105120).

	local myconf="--with-zlib \
		--with-html-subdir=${PF}/html \
		--docdir=/usr/share/doc/${PF} \
		$(use_with debug run-debug)  \
		$(use_with python)           \
		$(use_with readline)         \
		$(use_with readline history) \
		$(use_enable ipv6)"

	# Please do not remove, as else we get references to PORTAGE_TMPDIR
	# in /usr/lib/python?.?/site-packages/libxml2mod.la among things.
	elibtoolize

	# filter seemingly problematic CFLAGS (#26320)
	filter-flags -fprefetch-loop-arrays -funroll-loops

	econf $myconf

	# Patching the Makefiles to respect get_libdir
	# Fixes BUG #86766, please keep this.
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	for x in $(find "${S}" -name "Makefile") ; do
		sed \
			-e "s|^\(PYTHON_SITE_PACKAGES\ =\ \/usr\/\).*\(\/python.*\)|\1$(get_libdir)\2|g" \
			-i ${x} \
			|| die "sed failed"
	done

	emake || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" \
		EXAMPLES_DIR=/usr/share/doc/${PF}/examples \
		docsdir=/usr/share/doc/${PF}/python \
		exampledir=/usr/share/doc/${PF}/python/examples \
		install || die "Installation failed"

	dodoc AUTHORS ChangeLog Copyright NEWS README* TODO* || die "dodoc failed"
	rm "${D}"/usr/share/doc/${P}/Copyright
	rm -rf "${D}"/usr/share/doc/${P}

	if ! use python; then
		rm -rf "${D}"/usr/share/doc/${PF}/python
		rm -rf "${D}"/usr/share/doc/${PN}-python-${PV}
	fi

	if ! use doc; then
		rm -rf "${D}"/usr/share/gtk-doc
		rm -rf "${D}"/usr/share/doc/${PF}/html
	fi

	if ! use examples; then
		rm -rf "${D}/usr/share/doc/${PF}/examples"
		rm -rf "${D}/usr/share/doc/${PF}/python/examples"
	fi
}

pkg_postinst() {
	if use python; then
		python_need_rebuild
		python_mod_optimize $(python_get_sitedir)
	fi

	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [ "${ROOT}" != "/" ]
	then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${ROOT}etc/xml/catalog"

		# we dont want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [ ! -e ${CATALOG} ]; then
			[ -d "${ROOT}etc/xml" ] || mkdir -p "${ROOT}etc/xml"
			/usr/bin/xmlcatalog --create > ${CATALOG}
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages
}
