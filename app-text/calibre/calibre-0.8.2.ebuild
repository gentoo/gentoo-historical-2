# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/calibre/calibre-0.8.2.ebuild,v 1.1 2011/05/24 09:49:28 scarabeus Exp $

EAPI=3
PYTHON_DEPEND=2:2.7
PYTHON_USE_WITH=sqlite

inherit python distutils eutils fdo-mime bash-completion multilib

DESCRIPTION="Ebook management application."
HOMEPAGE="http://calibre-ebook.com/"
SRC_URI="http://calibre-ebook.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=app-text/podofo-0.8.2
	>=app-text/poppler-0.12.3-r3[qt4,xpdf-headers]
	>=dev-libs/chmlib-0.40
	>=dev-libs/icu-4.4
	>=dev-python/beautifulsoup-3.0.5:python-2
	>=dev-python/dnspython-1.6.0
	>=dev-python/cssutils-0.9.7_alpha3
	>=dev-python/dbus-python-0.82.2
	>=dev-python/imaging-1.1.6
	>=dev-python/lxml-2.2.1
	>=dev-python/mechanize-0.1.11
	>=dev-python/python-dateutil-1.4.1
	>=dev-python/PyQt4-4.8.2[X,svg,webkit]
	>=media-gfx/imagemagick-6.5.9
	>=media-libs/libwmf-0.2.8
	virtual/libusb:0
	>=x11-misc/xdg-utils-1.0.2"

RDEPEND="${COMMON_DEPEND}
	>=dev-python/reportlab-2.1"

DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-0.6_rc5
	>=gnome-base/librsvg-2.0.0
	>=x11-misc/xdg-utils-1.0.2-r2"

S=${WORKDIR}/${PN}

pkg_setup() {
	python_set_active_version 2.7
}

src_prepare() {
	# Avoid sandbox violation in /usr/share/gnome/apps when linux.py
	# calls xdg-* (bug #258938).
	sed -e "s:'xdg-desktop-menu', 'install':'xdg-desktop-menu', 'install', '--mode', 'user':" \
		-e "s:xdg-icon-resource install:xdg-icon-resource install --mode user:" \
		-e "s:xdg-mime install:xdg-mime install --mode user:" \
		-i src/calibre/linux.py || die "sed'ing in the IMAGE path failed"

	# Disable unnecessary privilege dropping for bug #287067.
	sed -e "s:if os.geteuid() == 0:if False and os.geteuid() == 0:" \
		-i setup/install.py || die "sed'ing in the IMAGE path failed"

	distutils_src_prepare
}

src_install() {

	# Bypass kbuildsycoca and update-mime-database in order to
	# avoid sandbox violations if xdg-mime tries to call them.
	cat - > "${T}/kbuildsycoca" <<-EOF
	#!${BASH}
	exit 0
	EOF

	cp "${T}"/{kbuildsycoca,update-mime-database}
	chmod +x "${T}"/{kbuildsycoca,update-mime-database}

	# --bindir and --sharedir don't seem to work.
	# Pass them in anyway so we'll know when they are fixed.
	# Unset DISPLAY in order to prevent xdg-mime from triggering a sandbox
	# violation with kbuildsycoca as in bug #287067, comment #13.
	export -n DISPLAY

	# Bug #352625 - Some LANGUAGE values can trigger the following ValueError:
	#   File "/usr/lib/python2.6/locale.py", line 486, in getdefaultlocale
	#    return _parse_localename(localename)
	#  File "/usr/lib/python2.6/locale.py", line 418, in _parse_localename
	#    raise ValueError, 'unknown locale: %s' % localename
	#ValueError: unknown locale: 46
	export -n LANGUAGE

	# Bug #295672 - Avoid sandbox violation in ~/.config by forcing
	# variables to point to our fake temporary $HOME.
	export HOME="${T}/fake_homedir"
	export XDG_CONFIG_HOME="${HOME}/.config"
	export XDG_DATA_HOME="${HOME}/.local/share"
	export CALIBRE_CONFIG_DIRECTORY="${XDG_CONFIG_HOME}/calibre"
	mkdir -p "${XDG_CONFIG_HOME}" "${CALIBRE_CONFIG_DIRECTORY}"

	# Bug #334243 - respect LDFLAGS when building calibre-mount-helper
	export OVERRIDE_CFLAGS="$CFLAGS $LDFLAGS"

	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
		distutils_src_install --bindir="${D}usr/bin" --sharedir="${D}usr/share"

	grep -rlZ "${D}" "${D}" | xargs -0 sed -e "s:${D}:/:g" -i ||
		die "failed to fix harcoded \$D in paths"

	# Python modules are no longer installed in
	# site-packages, so remove empty dirs.
	find "${D}$(python_get_libdir)" -type d -empty -delete

	# This code may fail if behavior of --root, --bindir or
	# --sharedir changes in the future.
	local libdir=$(get_libdir)
	dodir /usr/${libdir}
	mv "${D}lib/calibre" "${D}usr/${libdir}/" ||
		die "failed to move libdir"
	find "${D}"lib -type d -empty -delete
	grep -rlZ "/usr/lib/calibre" "${D}" | \
		xargs -0 sed -e "s:/usr/lib/calibre:/usr/${libdir}/calibre:g" -i ||
		die "failed to fix harcoded libdir paths"

	find "${D}"share/calibre/man -type f -print0 | \
		while read -r -d $'\0' ; do
			if [[ ${REPLY} = *.[0-9]calibre.bz2 ]] ; then
				newname=${REPLY%calibre.bz2}.bz2
				mv "${REPLY}" "${newname}"
				doman "${newname}" || die "doman failed"
				rm -f "${newname}" || die "rm failed"
			fi
		done
	rmdir "${D}"share/calibre/man/* || \
		die "could not remove redundant man subdir(s)"
	rmdir "${D}"share/calibre/man || \
		die "could not remove redundant man dir"

	dodir /usr/bin
	mv "${D}bin/"* "${D}usr/bin/" ||
		die "failed to move bin dir"
	find "${D}"bin -type d -empty -delete

	dodir /usr/share
	mv "${D}share/"* "${D}usr/share/" ||
		die "failed to move share dir"
	find "${D}"share -type d -empty -delete

	# The menu entries end up here due to '--mode user' being added to
	# xdg-* options in src_prepare.
	dodir /usr/share/mime/packages
	chmod -fR a+rX,u+w,g-w,o-w "${HOME}"/.local
	mv "${HOME}"/.local/share/mime/packages/* "${D}"usr/share/mime/packages/ ||
		die "failed to register mime types"
	dodir /usr/share/icons
	mv "${HOME}"/.local/share/icons/* "${D}"usr/share/icons/ ||
		die "failed to install icon files"

	# Bug #358065 - Remove inappropriate mime types from *.desktop.
	sed -e "s:application/octet-stream;::g" \
		-e "s:application/pdf;::g" \
		-e "s:application/vnd.oasis.opendocument.text;::g" \
		-e "s:application/xhtml+xml;::g" \
		-e "s:text/html;::g" \
		-e "s:text/plain;::g" \
		-e "s:text/rtf;::g" \
		-i "${HOME}"/.local/share/applications/*.desktop \
		|| die "sed failed"

	domenu "${HOME}"/.local/share/applications/*.desktop ||
		die "failed to install .desktop menu files"

	dobashcompletion "${D}"etc/bash_completion.d/calibre
	rm -r "${D}"etc/bash_completion.d
	find "${D}"etc -type d -empty -delete

	python_convert_shebangs -r $(python_get_version) "${D}"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	python_mod_optimize /usr/$(get_libdir)/${PN}
	bash-completion_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
