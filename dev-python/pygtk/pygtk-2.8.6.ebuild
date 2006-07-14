# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-2.8.6.ebuild,v 1.5 2006/07/14 17:47:20 dertobi123 Exp $

inherit gnome.org python flag-o-matic

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"
SRC_URI="${SRC_URI}
	doc? ( http://www.pygtk.org/dist/pygtk2reference.tbz2 )"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ppc ~ppc64 ~sh ~sparc x86"
IUSE="opengl doc"

RDEPEND=">=dev-lang/python-2.3.5
	>=x11-libs/gtk+-2.8.0
	>=dev-libs/glib-2.8.0
	>=x11-libs/pango-1.10.0
	>=dev-libs/atk-1.8.0
	>=gnome-base/libglade-2.5.0
	>=dev-python/pycairo-0.9.0
	!arm? ( dev-python/numeric )
	opengl? ( virtual/opengl
		dev-python/pyopengl
		>=x11-libs/gtkglarea-1.99 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

src_unpack() {
	unpack ${A}
	if use doc; then
		unpack pygtk2reference.tbz2
	fi
	# disable pyc compiling
	mv ${S}/py-compile ${S}/py-compile.orig
	ln -s /bin/true ${S}/py-compile
}

src_compile() {
	use hppa && append-flags -ffunction-sections
	econf --enable-thread || die
	# possible problems with parallel builds (#45776)
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL MAPPING NEWS README THREADS TODO
	rm examples/Makefile*
	cp -r examples ${D}/usr/share/doc/${PF}/

	python_version
	mv ${D}/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py \
		${D}/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py-2.0
	mv ${D}/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth \
		${D}/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth-2.0

	if use doc; then
		cd ${S}/../
		dodir /usr/share/gtk-doc/html
		cp -pPR pygtk2reference	${D}/usr/share/gtk-doc/html/
	fi
}

src_test() {
	cd tests
	make check-local
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/share/pygtk/2.0/codegen /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py pygtk.py-[0-9].[0-9]
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth pygtk.pth-[0-9].[0-9]
	python_mod_compile /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/share/pygtk/2.0/codegen
	python_mod_cleanup
	rm -f ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.{py,pth}
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.py pygtk.py-[0-9].[0-9]
	alternatives_auto_makesym /usr/$(get_libdir)/python${PYVER}/site-packages/pygtk.pth pygtk.pth-[0-9].[0-9]
}
