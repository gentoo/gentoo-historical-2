# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/qtiplot/qtiplot-0.9.7.10.ebuild,v 1.2 2010/01/05 11:08:39 ssuominen Exp $

EAPI=2
inherit eutils qt4 fdo-mime python

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bindist doc"

LANGS="de es fr ja ru sv"
for l in ${LANGS}; do
	IUSE="${IUSE} linguas_${l}"
done

# qwtplot3d much modified from original upstream
# >=x11-libs/qwt-5.3 they are using trunk checkouts
CDEPEND="
	x11-libs/qt-opengl:4
	x11-libs/qt-qt3support:4
	x11-libs/qt-assistant:4
	x11-libs/qt-svg:4
	>=x11-libs/gl2ps-1.3.5
	>=dev-cpp/muParser-1.30
	>=dev-libs/boost-1.35.0
	>=sci-libs/liborigin-20090406:2
	!bindist? ( sci-libs/gsl )
	bindist? ( <sci-libs/gsl-1.10 )
	dev-libs/boost
	dev-tex/qtexengine"
# Still not working
#	media-libs/libemf
#	media-libs/emfengine"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	dev-python/sip
	doc? ( app-text/docbook-sgml-utils
		   app-text/docbook-xml-dtd:4.2 )"

RDEPEND="${CDEPEND}
	>=dev-lang/python-2.5
	dev-python/PyQt4[X]
	dev-python/pygsl
	sci-libs/scipy"

PATCHES=(
	"${FILESDIR}/${P}-syslibs.patch"
	"${FILESDIR}/${P}-docbuild.patch"
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${P}-build.conf.patch"
	"${FILESDIR}/${P}-sip.patch"
	"${FILESDIR}/${P}-gl2ps.patch"
	"${FILESDIR}/${P}-dont-install-qwt.patch"
	"${FILESDIR}/${P}-qtiplot.pro.patch"
	)

src_prepare() {
	qt4_src_prepare

	rm -rf 3rdparty/{liborigin,QTeXEngine} 3rdparty/qwtplot3d/3rdparty/gl2ps/

	python_version

	sed -i \
		-e "s:doc/${PN}/manual:doc/${PF}/html:" \
		-e "s:local/${PN}:$(get_libdir)/python${PYVER}/site-packages:" \
		qtiplot/qtiplot.pro || die " sed for qtiplot/qtiplot.pro failed"

	sed -i \
		-e '/INSTALLS.*.*documentation/d' \
		-e '/manual/d' \
		qtiplot.pro qtiplot/qtiplot.pro || die "sed for doc failed"

	# the lib$$suff did not work in the fitRational*.pro files
	sed -i \
		-e "s|/usr/lib\$\${libsuff}|/usr/$(get_libdir)|g" \
		fitPlugins/*/*.pro \
		|| die "sed fitRational* failed"

	for l in ${LANGS}; do
		if ! use linguas_${l}; then
			sed -i \
				-e "s:translations/qtiplot_${l}.ts::" \
				-e "s:translations/qtiplot_${l}.qm::" \
				qtiplot/qtiplot.pro || die
		fi
	done
	chmod -x qtiplot/qti_wordlist.txt

	sed \
		-e "s:GENTOOLIB:$(get_libdir):g" \
		-e "/^EMF_ENGINE_LIBS/s:^:#:g" \
		build.conf.example > build.conf
}

src_configure() {
	eqmake4
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		#doxygen Doxyfile || die "api building failed"
		cd manual
		emake || die "html docbook building failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die 'emake install failed'
	newicon qtiplot_logo.png qtiplot.png
	make_desktop_entry qtiplot "QtiPlot Scientific Plotting" qtiplot
	if use doc; then
		insinto /usr/share/doc/${PF}/html
		doins -r manual/html/* || die "install manual failed"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	if use doc; then
		elog "On the first start, do Help -> Choose Help Folder"
		elog "and select /usr/share/doc/${PF}/html"
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
