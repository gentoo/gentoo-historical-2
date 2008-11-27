# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails/rails-2.2.2.ebuild,v 1.1 2008/11/27 06:59:53 graaff Exp $

inherit ruby gems

DESCRIPTION="ruby on rails is a web-application and persistance framework"
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="2.2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="fastcgi"
DEPEND=">=dev-lang/ruby-1.8.5
	>=app-admin/eselect-rails-0.13
	>=dev-ruby/rake-0.8.3
	~dev-ruby/activerecord-2.2.2
	~dev-ruby/activeresource-2.2.2
	~dev-ruby/activesupport-2.2.2
	~dev-ruby/actionmailer-2.2.2
	~dev-ruby/actionpack-2.2.2"

RDEPEND="${DEPEND}
	fastcgi? ( >=dev-ruby/ruby-fcgi-0.8.6 )"

src_install() {
	gems_src_install
	# Rename slotted files that may clash so that eselect can handle
	# them
	mv "${D}/usr/bin/rails" "${D}/usr/bin/rails-${PV}"
	mv "${D}/${GEMSDIR}/bin/rails" "${D}/${GEMSDIR}/bin/rails-${PV}"
}

pkg_postinst() {
	einfo "To select between slots of rails, use:"
	einfo "\teselect rails"
	# Bring users to rails 2.2.x by default when updating
	eselect rails update 2.2
}

pkg_postrm() {
	# Drop users back to rails 2.1.x when they remove 2.2.x
	eselect rails update 2.1
}
