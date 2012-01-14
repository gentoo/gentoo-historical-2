# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/calibre/calibre-0.8.35.ebuild,v 1.1 2012/01/14 18:27:01 zmedico Exp $

EAPI=4
PYTHON_DEPEND=2:2.7
PYTHON_USE_WITH=sqlite

inherit python distutils eutils fdo-mime bash-completion-r1 multilib

DESCRIPTION="Ebook management application."
HOMEPAGE="http://calibre-ebook.com/"
SRC_URI="http://sourceforge.net/projects/calibre/files/${PV}/${P}.tar.xz"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE="+udisks"

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
	>=media-gfx/imagemagick-6.5.9[jpeg]
	>=media-libs/libwmf-0.2.8
	virtual/libusb:0
	>=x11-misc/xdg-utils-1.0.2"

RDEPEND="${COMMON_DEPEND}
	>=dev-python/reportlab-2.1
	udisks? ( sys-fs/udisks )"

DEPEND="${COMMON_DEPEND}
	>=dev-python/setuptools-0.6_rc5
	>=gnome-base/librsvg-2.0.0
	>=x11-misc/xdg-utils-1.0.2-r2"

S=${WORKDIR}/${PN}

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	# Fix outdated version constant.
	#sed -e "s#\\(^numeric_version =\\).*#\\1 (${PV//./, })#" \
	#	-i src/calibre/constants.py || \
	#	die "sed failed to patch constants.py"

	# Avoid sandbox violation in /usr/share/gnome/apps when linux.py
	# calls xdg-* (bug #258938).
	sed -e "s:'xdg-desktop-menu', 'install':\\0, '--mode', 'user':" \
		-e "s:check_call(\\['xdg-desktop-menu', 'forceupdate'\\]):#\\0:" \
		-e "s:xdg-icon-resource install:\\0 --mode user:" \
		-e "s:xdg-mime install:\\0 --mode user:" \
		-i src/calibre/linux.py || die "sed failed to patch linux.py"

	# Disable unnecessary privilege dropping for bug #287067.
	sed -e "s:if os.geteuid() == 0:if False and os.geteuid() == 0:" \
		-i setup/install.py || die "sed failed to patch install.py"

	sed -e "/^            self\\.check_call(qmc + \\[ext\\.name+'\\.pro'\\])$/a\
\\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ self.check_call(['sed', \
'-e', 's|^CFLAGS .*|\\\\\\\\0 ${CFLAGS}|', \
'-e', 's|^CXXFLAGS .*|\\\\\\\\0 ${CXXFLAGS}|', \
'-e', 's|^LFLAGS .*|\\\\\\\\0 ${LDFLAGS}|', \
'-i', 'Makefile'])" \
		-i setup/extensions.py || die "sed failed to patch extensions.py"

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
	export OVERRIDE_CFLAGS="$CFLAGS" OVERRIDE_LDFLAGS="$LDFLAGS"
	local libdir=$(get_libdir)
	[[ -n $libdir ]] || die "get_libdir returned an empty string"

	PATH=${T}:${PATH} PYTHONPATH=${S}/src${PYTHONPATH:+:}${PYTHONPATH} \
		distutils_src_install \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/${libdir}" \
		--staging-root="${ED}usr" \
		--staging-libdir="${ED}usr/${libdir}"

	grep -rlZ "${ED}" "${ED}" | xargs -0 sed -e "s:${D}:/:g" -i ||
		die "failed to fix harcoded \$D in paths"

	# Remove dummy calibre-mount-helper which is unused since calibre-0.8.25
	# due to bug #389515 (instead, calibre now calls udisks via dbus).
	rm "${ED}usr/bin/calibre-mount-helper" || die

	find "${ED}"usr/share/calibre/man -type f -print0 | \
		while read -r -d $'\0' ; do
			if [[ ${REPLY} = *.[0-9]calibre.bz2 ]] ; then
				newname=${REPLY%calibre.bz2}.bz2
				mv "${REPLY}" "${newname}"
				doman "${newname}"
				rm -f "${newname}" || die "rm failed"
			fi
		done
	rmdir "${ED}"usr/share/calibre/man/* || \
		die "could not remove redundant man subdir(s)"
	rmdir "${ED}"usr/share/calibre/man || \
		die "could not remove redundant man dir"

	# The menu entries end up here due to '--mode user' being added to
	# xdg-* options in src_prepare.
	dodir /usr/share/mime/packages
	chmod -fR a+rX,u+w,g-w,o-w "${HOME}"/.local
	mv "${HOME}"/.local/share/mime/packages/* "${ED}"usr/share/mime/packages/ ||
		die "failed to register mime types"
	dodir /usr/share/icons
	mv "${HOME}"/.local/share/icons/* "${ED}"usr/share/icons/ ||
		die "failed to install icon files"

	domenu "${HOME}"/.local/share/applications/*.desktop ||
		die "failed to install .desktop menu files"

	dobashcomp "${ED}"usr/etc/bash_completion.d/calibre
	rm -r "${ED}"usr/etc/bash_completion.d
	find "${ED}"usr/etc -type d -empty -delete

	python_convert_shebangs -r $(python_get_version) "${ED}"

	newinitd "${FILESDIR}"/calibre-server.init calibre-server
	newconfd "${FILESDIR}"/calibre-server.conf calibre-server
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	python_mod_optimize /usr/$(get_libdir)/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
